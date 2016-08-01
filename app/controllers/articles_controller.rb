class ArticlesController < ApplicationController
  #include check_user
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index,:show]
  # GET /articles
  def index
    # Article.reindex

    search_options = {
      fields: ["title^5","body^5","label^1"],
      match: :word_start,
      suggest: true,
      misspellings: {below: 2},
      order: {_score: :desc},
    }


    search_options[:where] = {category: params[:cat_id] } if params[:cat_id].present?
    @articles = Article.search params[:q], search_options
    @suggestion = @articles.suggestions if params[:q].present?
  end

  # GET /articles/1
  def show
    @article = Article.find(params[:id])
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  def create
    @article = Article.create_from_sir_trevor(params[:sir_trevor_content])
    redirect_to @article
  end

  # PATCH/PUT /articles/1
  def update
    @article.update_from_sir_trevor!(params[:sir_trevor_content])
    redirect_to @article, success: "Successfully updated #{@article.title}"
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end
end
