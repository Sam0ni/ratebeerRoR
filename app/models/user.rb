class User < ApplicationRecord
  has_many :ratings

  include RatingAverage

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
end
