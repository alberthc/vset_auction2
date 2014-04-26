class AddUserIdToUserInfos < ActiveRecord::Migration
  def change
    add_column :user_infos, :user_id, :integer
  end
end
