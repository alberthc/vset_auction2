class AuctionsController < ApplicationController
  before_action :admin_user,	 only: [:new, :create, :edit, :index, :destroy]

  def new
    @auction = Auction.new
    @auction_stat = AuctionStat.new
  end

  def show
    @auction = current_auction #Auction.find(params[:id])
    @auction_items = @auction.auction_items
    # @bids = Bid.all
    @total_pledged = 0
    @total_unpledged = 0

    # TODO: fix this later - don't hardcode school totals
    @total_USC = 0
    @total_UCLA = 0
    @total_UCI = 0
    @total_OTHER = 0
    for auction_item in @auction_items
      @max_bid = auction_item.max_bid
      if !@max_bid.nil?
        @total_pledged += auction_item.max_bid
        @user = auction_item.bids.last.user
        if !@user.nil?
          @user_info = @user.user_info
          if !@user_info.nil?
            @school = auction_item.bids.last.user.user_info.school
            if !@school.nil?
              if @school == UserInfo::USC
                @total_USC += auction_item.max_bid
              elsif @school == UserInfo::UCLA
                @total_UCLA += auction_item.max_bid
              elsif @school == UserInfo::UCI
                @total_UCI += auction_item.max_bid
              elsif @school == UserInfo::OTHER
                @total_OTHER += auction_item.max_bid
              end
            end
          end
        end
      else
        @total_unpledged += auction_item.min_bid
      end
    end
  end

  def create
    @auction = current_user.auctions.build(auction_params)
    @auction_stat = @auction.build_auction_stat(auction_stat_params)
    if @auction.save && @auction_stat.save
      flash[:success] = "New Auction created!"

      for auction in Auction.all
        if auction.active? && auction.id != @auction.id
          auction.active = false
          auction.save
          break
        end
      end

      redirect_to @auction
    else
      render 'new'
    end
  end

  def update
    @auction = Auction.find(params[:id])
    if @auction.update_attributes(auction_params)
      # Handle a successful update
      flash[:success] = "Auction updated"
      redirect_to @auction
    else
      render 'edit'
    end
  end

  def index
    @auctions = Auction.paginate(page: params[:page])
  end

  def destroy
    Auction.find(params[:id]).destroy
    flash[:success] = "Auction deleted"
    redirect_to auctions_url
  end

  private

    def auction_params
      params.require(:auction).permit(:name, :description, :start_time,
				:end_time, :banner_image_path, :active)
    end

    def auction_stat_params
      params.require(:auction_stat).permit(:funds_goal)
    end

    # Before filters

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
