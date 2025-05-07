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

    avg = ratings.joins(:beer).group("beers.style_id").average(:score)
    fav_style = avg.max_by { |_k, v| v }[0]
    Style.find(fav_style).name
  end

  def favorite_brewery
    return nil if ratings.empty?

    avg = ratings.joins(beer: :brewery).group("breweries.name").average(:score)
    avg.max_by { |_k, v| v }[0]
  end

  def member_of(beer_club_id)
    already_in = beer_clubs.map(&:id)
    already_in.find{ |id| id == beer_club_id }
  end

  def get_membership(beer_club_id)
    memberships.find_by beer_club_id: beer_club_id
  end

  def self.most_active(number)
    User.all.sort_by{ |u| -u.ratings.count }.slice(0, number)
  end
end
