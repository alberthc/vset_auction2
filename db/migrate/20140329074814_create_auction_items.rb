class CreateAuctionItems < ActiveRecord::Migration
  def change
    create_table :auction_items do |t|
      t.integer :auction_id
      t.string :image_path
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
