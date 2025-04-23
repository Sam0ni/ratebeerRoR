class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :name, uniqueness: true, presence: true

  include RatingAverage

  def to_s
    "#{brewery.name} - #{name}"
  end
end
