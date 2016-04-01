class Bid < ActiveRecord::Base
  belongs_to :auction_item, touch: true
  belongs_to :user

  validates :user_id, presence: true
  validates :auction_item_id, presence: true
  validates :amount, presence: true, numericality: { only_integer: true }
end
