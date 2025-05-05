class Style < ApplicationRecord
  has_many :beers
  has_many :ratings, through: :beers

  include RatingAverage
  include BestByAvg
  
end
