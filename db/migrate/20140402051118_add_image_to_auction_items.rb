class AddImageToAuctionItems < ActiveRecord::Migration
  def change
    add_attachment :auction_items, :image
  end
end
