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
      data = block['data']
      case block['type'].to_sym

      when :text
        self.create_text_block(body: data['text'])
      when :heading
        self.create_heading_text_block(body: data['text'])
      when :equation_text
        #replace new line characters with line break html tags
        self.create_equation_text_block(body: data['text'].gsub(/\n/,"<br>").strip)
      when :image
        if (data.key?("id"))
          uploaded_image = Image.find(data['id'])
        else
          absolute_path = data['file']['url']
          extension = File.extname(absolute_path)
          filename = File.basename(absolute_path, extension)
          uploaded_image = Image.find_by(body_secure_token: filename)
        end
        self.create_image_block(image: uploaded_image)
      when :video
        self.create_link_block(source: data['source'], video_id: data['remote_id'])
      when :equation
        equation_block = self.create_equation_block(
          equation: data['equation'],
          label: data['label']
        )

        #add any variables associated with this equation
        variables = data['variables']
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
    def create_from_sir_trevor(sir_trevor_content, user)
      article = Article.new
      article.save!(validate: false)
      article.update_from_sir_trevor!(sir_trevor_content, user)
      article
    end
  end
end
