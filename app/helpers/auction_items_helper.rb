module AuctionItemsHelper

  def get_max_bid(auction_item_id)
    @max_bid = Bid.where(auction_item_id: auction_item_id).order(amount: :desc).first

    if @max_bid != nil
      return @max_bid
    else
      return nil
    end
  end

end
