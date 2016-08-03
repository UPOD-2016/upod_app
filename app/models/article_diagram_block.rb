# ArticleDiagramBlock is a more specific {ArticleBlock}.
# It contains a diagram ID which links to a specific diagram
# ArticleDigramBlock belongs to {Diagram} and acts as an article block.
# It inherits ArticleBlock's attributes, methods and validations. As well
# has a one-to-one connections with {Diagram}.
# @see Diagram
# @see ArticleBlock
#
# author: Michael Roher, Kieran O'Driscoll (Validations), Steven Swartz (Implementation)
#
# == Schema Information
#
# Table name: article_diagram_blocks
#
#  id         :integer          not null, primary key
#  diagram_id :integer
#  code :text
#  caption :string(255)
#  height :integer
#  width  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ArticleDiagramBlock < ActiveRecord::Base
  belongs_to :diagram
  acts_as :article_block
  
  #based on http://www.w3schools.com/browsers/browsers_display.asp
  MAX_WIDTH = 1080
  MAX_HEIGHT = 1920

  validates :code, presence: true, length: { maximum: 65_535 }
  validates :caption, length: { maximum: 255 }
  validates :height, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: MAX_HEIGHT}
  validates :width, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: MAX_WIDTH}
  
  # Used by SirTrevor for editing this block
  def as_json
    {
      type: :diagram,
      data:
        {
          caption: caption,
		  code: code,
		  width: width,
		  height: height
        }
    }
  end
end
