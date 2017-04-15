require 'will_paginate/array'

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
    auction_item_id = params[:id]
    auction_item_query = "comments.auction_item_id = ? OR bids.auction_item_id = ?"
    auction_item_result = AuctionItem.includes(:comments, :bids).where(auction_item_query, auction_item_id, auction_item_id).order('bids.id ASC').references(:comments, :bids)

    if auction_item_result.nil? || auction_item_result.length == 0
      @auction_item = AuctionItem.find(auction_item_id)
      #fresh_when last_modified: @auction_item.updated_at.utc, etag: @auction_item
    else
      @auction_item = auction_item_result.first
      @max_bid = @auction_item.bids.last
      @max_bid_user = @max_bid.user
      @comments = @auction_item.comments.sort_by { |hsh| hsh[:created_at] }
      #fresh_when last_modified: @auction_item.updated_at.utc, etag: @auction_item
    end
    
    @bid = Bid.new
    @comment = Comment.new
  end

  def edit
    @auction_item = AuctionItem.find(params[:id])
    redirect_if_not_permitted(@auction_item.user, auction_items_url)
  end

  def update
    @auction_item = AuctionItem.find(params[:id])
    redirect_if_not_permitted(@auction_item.user, auction_items_url)
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
      @category_name = "All"
    else
      redirect_to root_url
    end
  end

  def category
    if !params[:id].nil?
      category_id = params[:id]
      @category_name = get_category_name(category_id)
      if category_id == AuctionItem::ALL
        @auction_items = get_all_auction_items
        render 'index'
      else
        category_items_query = "auction_id = ? AND category = ?"
        auction_items_result = AuctionItem.includes(:bids).where(category_items_query, current_auction.id, category_id)
        @auction_items = auction_items_result.paginate(page: params[:page], per_page: DEFAULT_NUM_GRID_ITEMS_PER_PAGE).order('id DESC')
        render 'index'
      end
    end
  end

  def last_10_bids
    @category_name = "Last 12 Bids"
    @bids = Bid.all.order('updated_at DESC')
    @bids.paginate(page: params[:page], per_page: 12)
    
    limit = 10
    @auction_items = Array.new
    for bid in @bids do
      auction_item = bid.auction_item
      if (not @auction_items.include? auction_item) && (auction_item.auction_id == current_auction.id)
        @auction_items.push auction_item
      end
      if @auction_items.length == limit
        break
      end
    end

    @auction_items = @auction_items.paginate(page: params[:page], per_page: 12)

    render 'index'
  end

  private

    def auction_item_params
      params.require(:auction_item).permit(:name, :description, :image,
				:category, :min_bid, :min_incr)
    end

    def get_category_name(id)
      case id.to_i
      when AuctionItem::BOOK
        return "Books"
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

    def redirect_if_not_permitted(user, url)
      if !admin_user? && user != current_user 
        redirect_to url
      end
    end

end
