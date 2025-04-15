class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  include RatingAverage

  def to_s
    "#{brewery.name} - #{name}"
  end
end
