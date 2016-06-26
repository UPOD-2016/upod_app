# == Schema Information
#
# Table name: article_constant_blocks
#
#  id          :integer          not null, primary key
#  constant_id :integer
#

class ArticleConstantBlock < ActiveRecord::Base
  belongs_to :constant
  acts_as :article_block

  validates :constant_id, presence: true
  validates :id, presence: true, uniqueness: true

end
