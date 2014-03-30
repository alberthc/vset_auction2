class AuctionItemsController < ApplicationController
  include AuctionItemsHelper

  before_action :signed_in_user, only: [:new, :edit, :update, :destroy]

  def new
    @auction_item = AuctionItem.new
  end

  def create
    @auction_item = current_user.auction_items.build(auction_item_params)
    
    if current_auction != nil
      @auction_item.auction = current_auction
    end

    if @auction_item.save
      flash[:success] = "New item created!"
      redirect_to auction_items_url
    else
      render 'new'
    end
  end

  def show
    @auction_item = AuctionItem.find(params[:id])
    @bid = Bid.new
    current_auction_item = @auction_item
    @max_bid = get_max_bid(@auction_item.id)
  end

  def edit
    @auction_item = AuctionItem.find(params[:id])
  end

  def update
    @auction_item = AuctionItem.find(params[:id])
    if @auction_item.update_attributes(auction_item_params)
      flash[:success] = "Auction item updated"
      redirect_to @auction_item
    else
      render 'edit'
    end
  end

  def destroy
    AuctionItem.find(params[:id]).destroy
    flash[:success] = "Item deleted"
    redirect_to auction_items_url
  end

  def index
    @auction_items = AuctionItem.paginate(page: params[:page])
  end

  private

    def auction_item_params
      params.require(:auction_item).permit(:name, :description, :image_path,
				:category, :min_bid, :min_incr)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

end
