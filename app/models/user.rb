class User < ActiveRecord::Base

	has_many :opened_issues, class_name: "Issue", foreign_key: "opener_id"
	has_many :received_issues, class_name: "Issue", foreign_key: "receiver_id"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :plate, {uniqueness: true,
												presence: true}
end
