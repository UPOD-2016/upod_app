# frozen_string_literal: true
# A diagram has many {ArticleDiagramBlock}. This is so a diagram can be reused
# in many articles.
# @see ArticleDiagramBlock
#
# Author: Kieran O'Driscoll (Validations)
#
# == Schema Information
#
# Table name: diagrams
#
#  id         :integer          not null, primary key
#  body       :text(65535)
#  label      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Diagram < ActiveRecord::Base
  has_many :article_diagram_blocks

  validates :body, presence: true, length: { maximum: 65_535 }
  validates :label, length: { maximum: 255 }, presence: true
end
