# frozen_string_literal: true
# author: Kieran O'Driscoll(Organization and overriding methods)

module Admin
  class ArticleDiagramBlocksController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = ArticleDiagramBlock.all.paginate(10, params[:page])
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   ArticleDiagramBlock.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
