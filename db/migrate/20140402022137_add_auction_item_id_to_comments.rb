class AddAuctionItemIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :auction_item_id, :integer
  end
end
