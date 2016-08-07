# frozen_string_literal: true
class EquationVariableCascadeRelationship < ActiveRecord::Migration
  def change
    remove_foreign_key :equation_block_variables, :article_equation_blocks
    add_foreign_key :equation_block_variables, :article_equation_blocks, dependent: :delete, on_delete: :cascade
  end
end
