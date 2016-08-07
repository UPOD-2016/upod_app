# frozen_string_literal: true
class AddImageToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :image, :string
  end
end
