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

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    avg = ratings.joins(:beer).group("beers.style").average(:score)
    avg.max_by { |_k, v| v }[0]
  end

  def favorite_brewery
    return nil if ratings.empty?

    avg = ratings.joins(beer: :brewery).group("breweries.name").average(:score)
    avg.max_by { |_k, v| v }[0]
  end
end
