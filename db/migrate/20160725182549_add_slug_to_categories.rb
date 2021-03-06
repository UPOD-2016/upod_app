# frozen_string_literal: true
#
# author: Kieran O'Driscoll
#
class AddSlugToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :slug, :string
    add_index :categories, :slug
  end
end
