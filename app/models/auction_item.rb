class AuctionItem < ActiveRecord::Base
  belongs_to :auction
  has_many :bids
  belongs_to :user

  validates :user_id, presence: true
  validates :auction_id, presence: true 
  validates :min_bid, numericality: { only_integer: true}
  validates :min_incr, numericality: { only_integer: true }

  # Constants

  # types
  BOOK = 1
  CLOTHING = 2
  FOOD = 3
  MUSIC = 4
  SERVICE = 5
  TECHNOLOGY = 6
  OTHER = 7
end
