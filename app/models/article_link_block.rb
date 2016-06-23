# == Schema Information
#
# Table name: article_link_blocks
#
#  id    :integer          not null, primary key
#  url   :string(255)
#  label :string(255)
#

class ArticleLinkBlock < ActiveRecord::Base
  acts_as :article_block

  validates :url, presence: true, length: {maximum: 255}
  validates :label, presence: true, length: {maximum: 255}



end
