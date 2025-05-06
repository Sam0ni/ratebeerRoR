module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    len = ratings.length
    ratings.reduce(0) { |sum, rating| sum + (rating.score.to_f / len) }
  end
end
