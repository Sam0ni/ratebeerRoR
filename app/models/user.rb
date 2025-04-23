class User < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships

  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 }, format: { with: /\d/, message: 'must include at least one digit' }
  validates :password, format: { with: /[A-Z]/, message: 'must include at least one capital letter' }
end
