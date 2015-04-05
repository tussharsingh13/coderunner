class Ourcontest < ActiveRecord::Base
validates :name,:start,:end, presence: true
 validates_uniqueness_of :name
end
