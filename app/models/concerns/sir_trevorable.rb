module SirTrevorable
  extend ActiveSupport::Concern
  included do
    def update_from_sir_trevor!(sir_trevor_content)
      self.categorizations.destroy_all

      self.blocks.destroy_all

      json = JSON.parse(sir_trevor_content)
      meta = json['meta']
      data = json['data']
      # If there are no blocks provided, we have to throw an error
      return if data.empty?

      data.each do |block|
        self.create_block_from_sir_trevor(block)
      end

      self.update_metadata_from_sir_trevor(meta)
    end

    def update_metadata_from_sir_trevor(meta)
      self.update_columns(title: meta['title'] || self.title)
      meta['subcategories'].each do |subcategory_id|
        self.categorizations.create(subcategory_id: subcategory_id)
      end
      return self.valid?
    end

    def create_block_from_sir_trevor(block)
      case block['type'].to_sym

      when :text, :equation_text, :heading
        self.create_text_block(body: block['data']['text'])
      when :image
        uploaded_image = Image.find(block['data']['id'])
        self.create_image_block(image: uploaded_image)
      when :video
        self.create_link_block(source: block['data']['source'], video_id: block['data']['remote_id'])
      when :equation
        equation_block = self.create_equation_block(equation: block['data']['equation'], label: block['data']['label'])

        #add any variables associated with this equation
        variables = block['data']['variables']
        if variables != nil
          variables.keys.each do |key|
            variable = EquationBlockVariable.new(variable: variables[key]["variable"],description: variables[key]["description"])
            variable.article_equation_block_id = equation_block.id
            variable.save!
          end
        end

      when :diagram
        self.create_diagram_block(code: block['data']['code'], caption: block['data']['caption'])
      end
    end

    def to_sir_trevor
      {data: self.blocks.collect { |block| block.specific.as_json } }.to_json
    end
  end

  module ClassMethods
    # Creates the Articles blocks using sir trevor
    #
    # @todo Document method
    # @todo complete image handling
    def create_from_sir_trevor(sir_trevor_content)
      article = Article.new
      article.save!(validate: false)
      article.update_from_sir_trevor!(sir_trevor_content)
      article
    end
  end
end
