class Contest < ActiveRecord::Base
 validates :name,:dateandtime,:duration, presence: true
 validates_uniqueness_of :name
end
