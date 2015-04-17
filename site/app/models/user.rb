class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :first_name,:last_name,:username,:email,:password,:college, presence: true
  validates_uniqueness_of :email,:username
  validates :username, format: { with: /\A[^#]*\z/,
    message: "Username must not contain #" }
end
