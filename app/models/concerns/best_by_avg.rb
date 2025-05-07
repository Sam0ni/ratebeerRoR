module BestByAvg
  extend ActiveSupport::Concern

  class_methods do
    def top(number)
      all.sort_by{ |b| -b.average_rating }.slice(0, number)
    end
  end
end
