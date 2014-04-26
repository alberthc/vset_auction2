class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.string :gender
      t.string :school

      t.timestamps
    end
  end
end
