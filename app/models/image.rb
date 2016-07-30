# An image can belong to many {ArticleImageBlock} so that images can be reused throughout
# articles. The uploader used is {SirTrevorImageUploader}.
# @see ArticleImageBlock
#
# author: Mike Roher
#
# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  body       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Image < ActiveRecord::Base
  has_many :article_image_blocks
  mount_uploader :body, SirTrevorImageUploader

  #validates :body, presence: true

  def self.create_from_file(file)
    image = Image.new
    image.body = file
    image.save!
    image
  end

  def self.md5_from_file(file)
    Digest::MD5.hexdigest(file.read.to_s)
  end
end
