class AddDefaultMinIncrToAuctionItems < ActiveRecord::Migration
  def change
    change_column :auction_items, :min_incr, :integer, default: 1
  end
end
