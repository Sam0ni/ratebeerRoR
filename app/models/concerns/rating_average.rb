module RatingAverage
  extend ActiveSupport::Concern
  
  def average_rating
    len = ratings.length
    mean = ratings.reduce(0) {|sum, rating| sum + rating.score.to_f/len}
    return mean
  end
  
 end