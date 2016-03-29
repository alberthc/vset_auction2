class RemoveAuctionIdFromBids < ActiveRecord::Migration
  def change
    remove_column :bids, :auction_id, :integer
  end
end
