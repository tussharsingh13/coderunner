class Ourproblem < ActiveRecord::Base
validates :name,:statement,:timelimit,:memory,:contestid,:code, presence: true
 validates_uniqueness_of :name,:code
 validates :code, format: { with: /\A[^ ]*\z/,
    message: "Code must not contain space" }
end
