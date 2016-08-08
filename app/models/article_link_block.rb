# frozen_string_literal: true
# ArticleLinkBlock is a more specific {ArticleBlock}.
# It contains an id, a source and a video id. ArticleLinkBlock acts as an
# article block. If more video formats are supported in the future, this class
# would be easier to maintain if it was abstract and inherited by each video
# format. With only 2 video formats, inheritance would add unneeded complexity.
#
# @see ArticleBlock
#
# author: Michael Roher, Kieran O'Driscoll (Validations), Steven Swartz
#
# == Schema Information
#
# Table name: article_link_blocks
#
#  id       :integer          not null, primary key
#  source   :string(255)
#  video_id :string(255)      not null
#
class ArticleLinkBlock < ActiveRecord::Base
  acts_as :article_block

  # validates the presence and length of the url block and label
  validates :source, presence: true, length: { maximum: 255 }
  validates :video_id, presence: true, length: { maximum: 255 }
  validate :video_source_must_be_in_list, :video_id_must_match_pattern

  # contains the acceptable sources and their corresponding character
  # set for a valid video_id
  SOURCE_PATTERNS = \
    Hash['youtube' => /^[A-Za-z0-9_-]{11}$/, 'vimeo' => /^[0-9]*$/]

  # Checks to see if the video source is either youtube or vimeo
  #
  # @return [Boolean] Whether the source was found in the hash
  def video_source_must_be_in_list
    unless SOURCE_PATTERNS.key?(source)
      errors.add(:source, 'video is from an unsupported website')
    end
  end

  # Checks to see if the video id is valid based on the video's source
  #
  # @return [Boolean] Whether the video id is valid
  def video_id_must_match_pattern
    if SOURCE_PATTERNS.key?(source) && !SOURCE_PATTERNS[source].match(video_id)
      errors.add(:video_id, 'invalid video link provided')
    end
  end

  # Returns the url to use when embedding the video in an iframe
  #
  # @return [String] url to use in src of iframe
  def embeddable_url
    return 'https://www.youtube.com/embed/' + video_id if source == 'youtube'
    return 'https://player.vimeo.com/video/' + video_id if source == 'vimeo'
  end

  # Returns the direct url to this video
  #
  # @return [String] url to use in src of iframe
  def direct_url
    return 'https://www.youtube.com/watch?v=' + video_id if source == 'youtube'
    return 'https://vimeo.com/' + video_id if source == 'vimeo'
  end

  # Used by SirTrevor for editing this block
  def as_json
    {
	  #sir trevor's default field names for video block must be used
      type: :video,
      data:
      {
        source: source,
        remote_id: video_id,
        url: direct_url
      }
    }
  end
end
