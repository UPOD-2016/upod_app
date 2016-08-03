class AddDiagramDimensions < ActiveRecord::Migration
  def change
	add_column :article_diagram_blocks, :height, :integer
	add_column :article_diagram_blocks, :width, :integer
  end
end
