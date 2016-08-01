class AddTextBlockInheritance < ActiveRecord::Migration
  def change
	add_column :article_text_blocks, :type, :string
  end
end
