class AuctionsController < ApplicationController
  before_action :admin_user, only: [:new, :create, :edit, :index, :destroy]

  def new
    @auction = Auction.new
    @auction_stat = AuctionStat.new
  end

  def show
    @auction = current_auction
  end

  def create
    auction_params[:active] = true
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

      set_auction_dirty

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
