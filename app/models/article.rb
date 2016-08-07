# An Article is made up of many blocks and is the complete model. It contains
# various blocks that make up its' look and feel.
# An Article is {Blockable} as well as {Searchable}
#
# author: Michael Roher, Kieran O'Driscoll (Validations), Steven Swartz,
#         Robert Morouey.
#
# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Article < ActiveRecord::Base
  has_many :blocks, class_name: 'ArticleBlock', foreign_key: :article_id
  has_many :contributions, class_name: 'Contributor', foreign_key: :article_id
  has_many :categorizations, dependent: :destroy
  has_many :subcategories, through: :categorizations
  has_many :searches


  # Validates the title and it's length
  validates :title, presence: true, length: { maximum: 255 }

  # Reindex article class after changes
  after_commit :reindex_article
  before_validation :set_article_slug,
    prepend: true

  # This include is defined in the blockable.rb concern. Essentially, it
  # provides a nice interface to interact with the various types of article
  # blocks. Instead of having to use the ArticleTextBlock, you can now use
  # article.create_text_block, ArticleEquationBlock is now
  # article.create_equation_block and so on and so forth.
  include Blockable
  include SirTrevorable

  searchkick \
    searchable:   %i(title body name label),
    match:        :word_start,
    callbacks:    :async

    extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  #Replaces old blocks associated with this article with new ones
  #@param block_json [json] the sir trevor form data representing each block
  def change_blocks(block_json)
    #remove old blocks
    self.blocks.destroy_all
    block_json.each do |block|
      self.create_block_from_sir_trevor(block)
    end
  end

  #Replaces old subcategories associated with this article with new ones
  #@param subcategory_ids [int[]] a hash of the subcategory_ids to associate with this article
  def change_subcategories(subcategory_ids)
    #remove old sub-categories
    self.categorizations.destroy_all
    subcategory_ids.each do |subcategory_id|
      self.categorizations.create(subcategory_id: subcategory_id)
    end
  end

  def excerpt(length = 255)
    text_blocks = blocks.map{ |b| b.specific.body if b.specific.respond_to?(:body)}
    return text_blocks.try(:first).try(:first, length)
  end

  def search_data
    {
      title:        title,
      name:         blocks.map{ |b| b.specific.name if b.specific.respond_to?(:name)},
      body:         blocks.map{ |b| b.specific.body if b.specific.respond_to?(:body)},
      label:        blocks.map{ |b| b.specific.label if b.specific.respond_to?(:label)},
      category:     subcategories.map(&:category_id)
    }.as_json
  end

  private

  def reindex_article
    Article.reindex
  end

  def set_article_slug
    update_column(:slug, title.parameterize)
  end
end
