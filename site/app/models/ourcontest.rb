class Ourcontest < ActiveRecord::Base
validates :name,:start,:end,:code, presence: true
 validates_uniqueness_of :name,:code
 validates :code, format: { with: /\A[^ ]*\z/,
    message: "Code must not contain space" }
end
