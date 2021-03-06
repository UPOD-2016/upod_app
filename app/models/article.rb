# frozen_string_literal: true
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

  # This include is defined in the blockable.rb concern. Essentially, it
  # provides a nice interface to interact with the various types of article
  # blocks. Instead of having to use the ArticleTextBlock, you can now use
  # article.create_text_block, ArticleEquationBlock is now
  # article.create_equation_block and so on and so forth.
  include Blockable
  include SirTrevorable
  extend FriendlyId

  searchkick \
    searchable:   %i(title body name label),
    match:        :word_start,
    callbacks:    :async

  friendly_id :slug_candidates, use: [:slugged, :finders]

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :title,
      [:title, :id],
    ]
  end


  # Replaces old blocks associated with this article with new ones
  # @param block_json [json] the sir trevor form data representing each block
  def change_blocks(block_json)

    #Removal of old blocks is rolled back on errors
    Article.transaction do
      blocks.destroy_all
      block_json.each do |block|
        create_block_from_sir_trevor(block)
      end
    end
  end

  # Replaces old subcategories associated with this article with new ones
  # @param subcategory_ids [int[]] a hash of the subcategory_ids to associate
  # with this article
  def change_subcategories(subcategory_ids)

    Article.transaction do
      #Removal of old categories are rolled back on errors
      categorizations.destroy_all
      subcategory_ids.each do |subcategory_id|
        categorizations.create(subcategory_id: subcategory_id)
      end
    end
  end

  # Returns the first n characters from the first text block in the article.
  def excerpt(length = 255)
    text_blocks = blocks.map { |b| b.specific.body if b.specific.respond_to?(:body) }
    ActionView::Base.full_sanitizer
    .sanitize(text_blocks.try(:first)
              .try(:first, length))
  end

  # Returns the data that will be flattened and indexed by the elastic search
  # core program
  # title = The title from each article
  # name = Name of each Category / Sub Category
  # label = labels from all the diagrams and images
  # category = id of the category which contain this article
  def search_data
    {
      title:        title,
      name:         blocks.map { |b| b.specific.name if b.specific.respond_to?(:name) },
      body:         blocks.map { |b| b.specific.body if b.specific.respond_to?(:body) },
      label:        blocks.map { |b| b.specific.label if b.specific.respond_to?(:label) },
      category:     subcategories.pluck(:category_id)
    }.as_json
  end

  private

  # Uses search_data method to re-index and flatten the searchable data in the
  # elastic search core
  def reindex_article
    Article.reindex
  end


end
