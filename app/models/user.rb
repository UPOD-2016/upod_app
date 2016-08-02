# User Class created by devise.
class User < ActiveRecord::Base
  has_many :contributions, class_name: 'Contributor', foreign_key: :user_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable,
         :trackable, :validatable
  validates_confirmation_of :password
  validates :email, presence: true
end
