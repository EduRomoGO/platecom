class Issue < ActiveRecord::Base
	has_many :comments

  belongs_to :opener, class_name: "User"
  belongs_to :receiver, class_name: "User"

end
