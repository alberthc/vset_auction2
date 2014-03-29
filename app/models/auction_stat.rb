class AuctionStat < ActiveRecord::Base
  belongs_to :auction
  validates :auction_id, presence: true
end
