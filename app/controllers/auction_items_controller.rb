class AuctionItemsController < ApplicationController
  include AuctionItemsHelper

  before_action :signed_in_user, only: [:new, :edit, :update, :destroy]
  before_action :auction_over, only: [:new, :edit, :update, :destroy, :create]

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
    #@auction_item = AuctionItem.find(params[:id])
    auction_item_id = params[:id]
    auction_item_query = "comments.auction_item_id = ? OR bids.auction_item_id = ?"
    auction_item_result = AuctionItem.includes(:comments, :bids).where(auction_item_query, auction_item_id, auction_item_id).references(:comments, :bids)

    if auction_item_result.nil? || auction_item_result.length == 0
      @auction_item = AuctionItem.find(auction_item_id)
    else
      @auction_item = auction_item_result[0]
      #@max_bid = get_max_bid(@auction_item.id)
      @max_bid = @auction_item.bids.last
      @max_bid_user = @max_bid.user
      @comments = @auction_item.comments
    end
    
    @bid = Bid.new
    @comment = Comment.new
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
    if signed_in?
      @auction_items = AuctionItem.where(auction_id: current_auction.id).paginate(page: params[:page], per_page: 25, conditions: {}).order('id DESC')
    else
      redirect_to root_url
    end
  end

  def category
    if !params[:id].nil?
      @category_name = "Category" #get_category_name(params[:id])
      if params[:id] == AuctionItem::ALL
        @auction_items = AuctionItem.paginate(page: params[:page], per_page: 25).where(auction_id: current_auction.id).order('id DESC')
        render 'index'
      else
        @auction_items = AuctionItem.where(category: params[:id]).paginate(page: params[:page], per_page: 25).where(auction_id: current_auction.id).order('id DESC')
        render 'index'
      end
    end
  end

  private

    def auction_item_params
      params.require(:auction_item).permit(:name, :description, :image,
				:category, :min_bid, :min_incr)
    end

    def get_category_name(id)
      case id
      when AuctionItem::BOOK
        return "Book"
      when AuctionItem::CLOTHING
        return "Clothing"
      when AuctionItem::FOOD
        return "Food"
      when AuctionItem::MUSIC
        return "Music"
      when AuctionItem::SERVICE
        return "Services"
      when AuctionItem::TECHNOLOGY
        return "Technology"
      else
        return "Other"
      end
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def auction_over
      if DateTime.now.to_date >= current_auction.end_time
	redirect_to :back
      end
    end

end
