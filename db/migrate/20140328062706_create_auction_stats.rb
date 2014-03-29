class CreateAuctionStats < ActiveRecord::Migration
  def change
    create_table :auction_stats do |t|
      t.integer :auction_id
      t.integer :funds_raised
      t.integer :funds_goal

      t.timestamps
    end
  end
end
