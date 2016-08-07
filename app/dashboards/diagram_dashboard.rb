# frozen_string_literal: true
# author: Kieran O'Driscoll(Organization and overriding methods)

require 'administrate/base_dashboard'

class DiagramDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    article_diagram_blocks: Field::HasMany,
    id: Field::Number,
    body: Field::Text,
    label: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :body,
    #:article_diagram_blocks,
    :label
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :body,
    :label,
    :article_diagram_blocks,
    #:created_at,
    #:updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    #:article_diagram_blocks,
    :body,
    :label
  ].freeze

  # Overwrite this method to customize how diagrams are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(diagram)
  #   "Diagram ##{diagram.id}"
  # end
end
