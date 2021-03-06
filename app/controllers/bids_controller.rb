class BidsController < ApplicationController
  include AuctionItemsHelper

  before_action :auction_over, only: [:create]

  def create
    @bid = current_user.bids.build(bid_params)
    
    @max_bid = get_max_bid(@bid.auction_item_id)

    if validate_bid?(@bid, @max_bid) && @bid.save
      @bid.auction_item.max_bid = @bid.amount
      @bid.auction_item.save
      flash[:success] = "Bid submitted!"
      redirect_to @bid.auction_item

      @comment = @bid.auction_item.comments.build(comment_params)
      @comment.user = current_user
      @comment.save
    else
      @bid.errors.add(:amount, "Bid must be at least the minimum and bid must be
        raised by at least the minimum increment value.")
      @auction_item = AuctionItem.where(id: bid_params[:auction_item_id]).first
      @comment = Comment.new
      @comments = Comment.where(auction_item: @auction_item)
      #render "/auction_items/#{@auction_item_id}"
      render 'auction_items/show', auction_item: @auction_item, bid: @bid,
        comments: @comments
    end
  end

  private

    def bid_params
      params.require(:bid).permit(:amount, :auction_item_id)
    end

    def comment_params
      params.require(:comment).permit(:content)
    end

    # Must be greater than min_bid
    # Must be greater than the current max bid
    #
    # Returns true or false
    def validate_bid?(bid, max_bid)
      if bid == nil || bid.amount == nil
	bid.errors.add(:amount, "Must enter bid")
	return false
      end

      @auction_item = bid.auction_item

      if @auction_item == nil
	bid.errors.add(:auction_item, "Not associated with auction item")
	return false
      elsif max_bid == nil
	if bid.amount >= @auction_item.min_bid
	  return true
	else
	  return false
	end
      end

      if bid.amount >= @auction_item.min_bid &&
	bid.amount >= max_bid.amount + @auction_item.min_incr
	return true
      end

      return false
    end

    # Before filters

    def auction_over
      if DateTime.now.to_date >= current_auction.end_time
        redirect_to :back
      end
    end

end
