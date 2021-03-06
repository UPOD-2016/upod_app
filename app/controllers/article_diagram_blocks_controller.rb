# frozen_string_literal: true
# The article diagram block controller is used
# to render diagrams containing potentially unsafe javascript
# so that the page can be more safely included in a sandboxed iframe
# when rendering this diagram within articles
#
# @see ArticleDiagramBlock
#
# author: Steven Swartz
class ArticleDiagramBlocksController < ApplicationController
  before_action :set_article_diagram_block,
                only: [:show, :edit, :update, :destroy]

  # Renders a diagram or html which is used in a sandboxed iframe when rendering
  # this block's partial in an article
  def show
    # Get the html, svg, css, and js code to render
    @code = get_article_code

    # The default layouts are not added as this page will be
    # embeded in an iframe
    render layout: false
  end

  private

  def get_article_code
    return 'This diagram is not available' if @article_diagram_block.nil?
    @article_diagram_block.code
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_article_diagram_block
    # Get the record if it exists

    @article_diagram_block = ArticleDiagramBlock.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @article_diagram_block = nil
  end
end
