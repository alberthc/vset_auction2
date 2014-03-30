class RemoveTypeFromAuctionItems < ActiveRecord::Migration
  def change
    remove_column :auction_items, :type
  end
end
