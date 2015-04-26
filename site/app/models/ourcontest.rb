class Ourcontest < ActiveRecord::Base
validates :name,:start,:end,:code, presence: true
 validates_uniqueness_of :name,:code
 validates :code, format: { with: /\A[^ .]*\z/,
    message: "Code must not contain space or dot" }
    
validate :start_should_be_valid,
    :end_should_be_greater_than_start
    
 
  def start_should_be_valid
    if start < Time.zone.now.to_datetime
      errors.add(:start, "can't be in the past")
    end
  end
  
  def end_should_be_greater_than_start
    if self.end <= self.start
      errors.add(:end, "should be greater than start")
    end
  end
end
