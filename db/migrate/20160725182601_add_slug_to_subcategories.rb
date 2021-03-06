# frozen_string_literal: true
#
# author: Kieran O'Driscoll
#
class AddSlugToSubcategories < ActiveRecord::Migration
  def change
    add_column :subcategories, :slug, :string
    add_index :subcategories, :slug
  end
end
