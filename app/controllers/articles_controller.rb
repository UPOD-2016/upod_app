# frozen_string_literal: true
# Controller for /articles/ path.  Implements CRUD actions
class ArticlesController < ApplicationController
  # Include check_user
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  after_action :reindex_articles_after_touching, only: [:create, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:index, :show]
  # GET /articles
  def index
    redirect_to Category.find(params[:cat_id]) if cat_only?

    search_options = read_search_options
    search_options[:where] = { category: params[:cat_id] } \
    if params[:cat_id].present?

    @articles = Article.search params[:q], search_options
    end

  # GET /articles/1
  def show
    @article = Article.find(params[:id])
    search_options = read_search_options
    search_options[:operator] = 'or'
    query = @article.title.split(' ').select{|w| w.length >= 4} * (' ')
    @related = Article.search query, search_options
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
    # used when populating checkboxes to avoid querying for each subcategory when determining if the article belongs to it
    @article_subcategory_ids = @article.subcategory_ids
  end

  # POST /articles
  def create
    @article = Article.create_from_sir_trevor(params[:sir_trevor_content], current_user)
    redirect_to @article
  end

  # PATCH/PUT /articles/1
  def update
    @article.update_from_sir_trevor!(params[:sir_trevor_content], current_user)
    redirect_to @article, success: 'Successfully updated #{@article.title}'
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
  end

  private

  def read_search_options
    {
      fields: %w(title^10 name body label),
      match: :word_start,
      misspellings: { edit_distance: 1 },
      # order: { _score: :desc },
      boost_where: { title: :exact }
    }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  def cat_only?
    params[:cat_id].present? && params[:q].blank?
  end

  def reindex_articles_after_touching
    Article.reindex
  end
  end
