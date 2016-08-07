# frozen_string_literal: true
# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  body       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :image do
    body 'MyString'
  end
end
