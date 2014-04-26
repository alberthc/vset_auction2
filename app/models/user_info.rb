class UserInfo < ActiveRecord::Base
  belongs_to :user

  # Constants

  USC = "USC"
  UCLA = "UCLA"
  UCI = "UCI"

end
