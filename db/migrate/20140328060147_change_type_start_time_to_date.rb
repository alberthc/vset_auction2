class ChangeTypeStartTimeToDate < ActiveRecord::Migration
  def change
    change_column :auctions, :start_time, :date
  end
end
