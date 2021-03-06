# frozen_string_literal: true
#
# author: Kieran O'Driscoll
#
class AddSlugToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :slug, :string
    add_index :articles, :slug
  end
end
