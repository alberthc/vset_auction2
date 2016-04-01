module CacheHelper

  def cache_fetch(cache_key, expire_time, fetch_from_disk)
    Rails.cache.fetch(cache_key, expires_in: expire_time) do
      fetch_from_disk.call
    end
  end

  def cache_key_for_all_auction_items
    count = AuctionItem.count
    max_updated_at = AuctionItem.maximum(:updated_at).try(:to_s, :number)
    "auction_items/all-#{count}-#{max_updated_at}"
  end

  def cache_key_for_auction_item(auction_item)
    "auction_item/#{auction_item.id}-#{auction_item.updated_at}"
  end

  def cache_key_for_current_auction
    count = Auction.count
    max_updated_at = Auction.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "auctions/current-#{count}-#{max_updated_at}"
  end

  def cache_key_for_current_auction_stats
    count = AuctionItem.count
    max_updated_at = AuctionItem.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "auctions/current/stats-#{count}-#{max_updated_at}"
  end

  def cache_key_for_current_user
    current_user_id = cookies[:current_user_id]
    remember_token = User.hash(cookies[:remember_token])
    if current_user_id.nil?
      new_current_user = get_new_current_user
      if new_current_user.nil?
        current_user_id = -1
      else
        current_user_id = new_current_user.id
        cookies.permanent[:current_user_id] = current_user_id
        current_user_id = current_user_id
      end
    end

    return "current_user#{current_user_id}-#{remember_token}"
  end

end
