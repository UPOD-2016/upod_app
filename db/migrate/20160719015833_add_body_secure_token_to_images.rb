# frozen_string_literal: true
class AddBodySecureTokenToImages < ActiveRecord::Migration
  def change
    add_column :images, :body_secure_token, :string
  end
end
