# frozen_string_literal: true
# author: Kieran O'Driscoll(Organization and overriding methods)

module Admin
  class ArticlesController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Article.all.paginate(10, params[:page])
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Article.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information

    def new
      redirect_to new_article_url
    end

    def edit
      redirect_to edit_article_url
    end

    def show
      redirect_to article_path
    end
  end
end
