module BestByAvg
  extend ActiveSupport::Concern
  
  class_methods do
    def top(n)
      sorted_by_rating_avg = self.all.sort_by{ |b| -b.average_rating }.slice(0, n)
    end
  end
end