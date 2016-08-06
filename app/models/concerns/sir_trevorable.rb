module SirTrevorable
  extend ActiveSupport::Concern
  included do
    def update_from_sir_trevor!(sir_trevor_content, user)
      json = JSON.parse(sir_trevor_content)
      #update title without overwriting an existing title with nil
      self.update_columns(title: json['meta']['title'] || self.title)

      self.change_blocks(json['data'])

      self.change_subcategories(json['meta']['subcategories'])

      self.contributions.where(user: user).first_or_create
    end

    def create_block_from_sir_trevor(block)
      case block['type'].to_sym

      when :text
        self.create_text_block(body: block['data']['text'])
      when :heading
        self.create_heading_text_block(body: block['data']['text'])
      when :equation_text
        #replace new line characters with line break html tags
        self.create_equation_text_block(body: block['data']['text'].gsub(/\n/,"<br>").strip)
      when :image
        uploaded_image = Image.find(block['data']['id'])
        self.create_image_block(image: uploaded_image)
      when :video
        self.create_link_block(source: block['data']['source'], video_id: block['data']['remote_id'])
      when :equation
        equation_block = self.create_equation_block(
          equation: block['data']['equation'],
          label: block['data']['label']
        )

        #add any variables associated with this equation
        variables = block['data']['variables']
        unless variables.nil?
          variables.keys.each do |key|
            variable = EquationBlockVariable.new(
              variable: variables[key]["variable"],
              description: variables[key]["description"]
            )
            variable.article_equation_block_id = equation_block.id
            variable.save!
          end
        end

      when :diagram
        self.create_diagram_block(
          code: block['data']['code'],
          caption: block['data']['caption'],
          height: block['data']['height'],
          width: block['data']['width']
        )
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
