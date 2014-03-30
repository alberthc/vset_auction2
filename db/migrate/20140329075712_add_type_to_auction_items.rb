class AddTypeToAuctionItems < ActiveRecord::Migration
  def change
    add_column :auction_items, :type, :string
  end
end
