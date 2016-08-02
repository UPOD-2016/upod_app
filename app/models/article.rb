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
  has_many :categorizations
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

  searchkick \
    searchable:   %i(title body name label),
    match:        :word_start,
    callbacks:    :async,
    conversions:  :converstions

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  def should_generate_new_friendly_id?
    new_record?
  end

  def search_data
    {
      title:        title,
      name:         blocks.select { |b| b.specific.respond_to? :body }
                          .map    { |b| b.specific.body },
      body:         blocks.select { |b| b.specific.respond_to? :body }
                          .map    { |b| b.specific.body },
      label:        blocks.select { |b| b.specific.respond_to? :body }
                          .map    { |b| b.specific.body },
      category:     subcategories.map(&:category_id),
      conversions:  searches.group('query').count
    }.as_json
  end

  def reindex_article
    Article.reindex
  end
end
