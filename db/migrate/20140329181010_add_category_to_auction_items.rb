class AddCategoryToAuctionItems < ActiveRecord::Migration
  def change
    add_column :auction_items, :category, :integer
  end
end
