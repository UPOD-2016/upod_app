# ArticleTestBlock is a more specific {ArticleBlock}.
# It is a generic block that contains a body attribute.
# Other blocks that can be represented by a single string
# should inherit this block and provide a unique partial html
# view when rendered in articles.
# The body of the text block is {Searchable}
# 
# @see ArticleBlock
#
# author: Michael Roher, Kieran O'Driscoll (Validations), Steven Swartz
#
# == Schema Information
#
# Table name: article_text_blocks
#
#  id   :integer          not null, primary key
#  body :text(65535)
#  type :text(256)
#
class ArticleTextBlock < ActiveRecord::Base
  acts_as :article_block
  #single table inheritance of subclasses through the database column "type"
  self.inheritance_column = :type 

# validates the presence and length of the body of title block
  validates :body, presence: true, length: { maximum: 65535 }

  # Used by SirTrevor for updating
  def as_json
	{
	  type: :text,
      data: {
        text: self.body,
        format: :html
      }
    }
  end
end
