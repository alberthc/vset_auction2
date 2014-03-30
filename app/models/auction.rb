class Auction < ActiveRecord::Base
  belongs_to :user
  has_one :auction_stat
  has_many :auction_items
  
  validates :user_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end
