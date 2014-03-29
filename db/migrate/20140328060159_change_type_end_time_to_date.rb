class ChangeTypeEndTimeToDate < ActiveRecord::Migration
  def change
    change_column :auctions, :end_time, :date
  end
end
