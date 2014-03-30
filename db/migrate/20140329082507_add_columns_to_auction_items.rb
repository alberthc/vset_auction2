class AddColumnsToAuctionItems < ActiveRecord::Migration
  def change
    add_column :auction_items, :user_id, :integer
    add_column :auction_items, :min_bid, :integer
    add_column :auction_items, :min_incr, :integer
  end
end
