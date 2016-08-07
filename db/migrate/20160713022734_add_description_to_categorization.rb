# frozen_string_literal: true
class AddDescriptionToCategorization < ActiveRecord::Migration
  def change
    add_column :categorizations, :description, :string
  end
end
