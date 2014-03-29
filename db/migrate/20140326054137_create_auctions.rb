class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.integer :user_id
      t.datetime :start_time
      t.datetime :end_time
      t.string :name
      t.text :description
      t.string :banner_image_path
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
