class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :auction_item

  default_scope -> { order('created_at ASC') }

  validates :user_id, presence: true
  validates :auction_item_id, presence: true
  validates :content, presence: true, allow_blank: false
end
