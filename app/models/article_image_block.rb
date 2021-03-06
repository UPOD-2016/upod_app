# frozen_string_literal: true
# ArticleImageBlock is a more specific {ArticleBlock}.
# It inherits ArticleBlock's attributes, methods and validations. It also has a
# one-to-one connection with {Image}
# @see ArticleBlock
# @see Image
#
# author: Michael Roher, Kieran O'Driscoll (Validations)
#
#
# == Schema Information
#
# Table name: article_image_blocks
#
#  id         :integer          not null, primary key
#  image_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ArticleImageBlock < ActiveRecord::Base
  belongs_to :image
  acts_as :article_block

  def image_url(size = nil)
    image.body.url(size)
  end

  def as_json
    {
      id: image.id,
      type: :image,
      data: {
        file: {
          url: image_url
        }
      }
    }
  end
end
