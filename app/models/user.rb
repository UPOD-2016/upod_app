# frozen_string_literal: true
# User Class created by devise.
class User < ActiveRecord::Base
  has_many :contributions, class_name: 'Contributor', foreign_key: :user_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable,
         :trackable, :validatable
  validates :password, confirmation: true
  validates :email, presence: true
end
