class Problem < ActiveRecord::Base
validates :name,:statement,:timelimit,:memory ,presence: true
 validates_uniqueness_of :name
end
