# frozen_string_literal: true
# ArticleEquationBlock is a more specific {ArticleBlock}. It represents
# an equation which has many {EquationBlockVariable} which encapsulate
# a mathematical expression with descriptions of variables that it includes.
# It inherits ArticleBlock's attributes, methods and validations.
#
# @see ArticleBlock
# @see EquationBlockVariables
#
# author: Michael Roher, Kieran O'Driscoll (Validations), Steven Swartz (Implementation)
#
# == Schema Information
#
# Table name: article_equation_blocks
#
#  id       :integer          not null, primary key
#  equation :text
#  label    :string(255)
#
class ArticleEquationBlock < ActiveRecord::Base
  acts_as :article_block
  has_many :equation_block_variables, dependent: :destroy

  # Validates the length and presence of equation block and description
  validates :equation, presence: true, length: { maximum: 65_535 }
  validates :label, length: { maximum: 255 }

  # Used by SirTrevor for editing this block
  # Get each variable associated with this equation and add each of their
  # hashes to the variables hash
  def as_json
    variables = {}
    equation_block_variables.each_with_index do |variable, index|
      variables[index] = variable.as_json
    end

    {
      type: :equation,
      data: { equation: equation, label: label, variables: variables }
    }
  end
end
