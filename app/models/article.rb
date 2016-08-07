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
    callbacks:    :async#,
    #conversions:  :converstions

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
    text_blocks = get_specific_blocks(:body)
    unless text_blocks.blank? || text_blocks.first.blank?
      return text_blocks.first.body.truncate(length: length)
    else
      return ''
    end
  end

  def search_data
    {
      title:        title,
      name:         get_specific_blocks(:name),
      body:         get_specific_blocks(:body),
      label:        get_specific_blocks(:label),
      category:     subcategories.map(&:category_id)#,
      #conversions:  searches.group('query').count
    }.as_json
  end

  private

  def reindex_article
    Article.reindex
  end

  def get_specific_blocks(sym)
    blocks.select { |b| b.specific.respond_to? :sym }.map { |b| b.specic.sym }
  end

  def set_article_slug
    update_column(:slug, title.parameterize)
  end
end
