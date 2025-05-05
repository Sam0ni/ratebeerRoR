module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    len = ratings.length
    avg = ratings.reduce(0) { |sum, rating| sum + (rating.score.to_f / len) }
    avg.round(2)
  end
end
