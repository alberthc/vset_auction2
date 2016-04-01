module AuctionItemsHelper

  def get_max_bid(auction_item_id)
    @max_bid = Bid.where(auction_item_id: auction_item_id).order(amount: :desc).first

    if @max_bid != nil
      return @max_bid
    else
      return nil
    end
  end

  def get_all_auction_items
    auction_items_result = AuctionItem.includes(:bids).where(auction_id: current_auction.id)
    @auction_items = auction_items_result.paginate(page: params[:page], per_page: 20).order('id DESC')
  end

end
