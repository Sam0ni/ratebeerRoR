class Beer < ApplicationRecord
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true

  include RatingAverage

  def to_s
    "#{brewery.name} - #{name}"
  end

  def self.top(n)
    sorted_by_rating_avg = Beer.all.sort_by{ |b| -b.average_rating}.slice(0, n)
  end
end
