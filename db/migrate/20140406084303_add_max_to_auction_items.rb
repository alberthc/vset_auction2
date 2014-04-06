class AddMaxToAuctionItems < ActiveRecord::Migration
  def change
    add_column :auction_items, :max_bid, :integer
  end
end
