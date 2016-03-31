class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def new
    @user = User.new
    @user_info = UserInfo.new
  end

  def show
    user_id = params[:id]
    user_result = User.includes(:user_info, :bids).where(id: user_id)
    @user = user_result.first
    @user_info = @user.user_info

    if !@user.auction_items.nil?
      my_items_result = @user.auction_items.includes(:bids).where(auction_id: current_auction.id).order('LOWER(name) ASC')
      @my_items = my_items_result.paginate(page: params[:page], per_page: 10).order('LOWER(name) ASC')
    end

    # @following_items are AuctionItems that the user has bid on 
    @following_items = AuctionItem.includes(:bids).where("auction_id = ? AND bids.user_id = ?", current_auction.id, @user.id).order('bids.id DESC')
    
    @total_pledged = get_total_pledged(@user, @following_items)

    if @user == current_user
      @user_name_header = "My"
    else
      @user_name_header = @user.name + "'s"
    end
  end

  def create
    @user = User.new(user_params)
    @user_info = UserInfo.new(user_info_params)
    if @user.save
      @user_info.user = @user
      @user_info.save

      sign_in @user
      flash[:success] = "Welcome to the VSET Auction!"
      if current_auction != nil
        redirect_to current_auction
      end
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @user_info = @user.user_info
    if @user_info.nil?
      @user_info = UserInfo.new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      @user_info = @user.user_info
      @user_info.update_attributes(user_info_params)
      # Handle a successful update
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page]).order('LOWER(name) ASC')
    #max_updated_at = @users.maximum(:updated_at).try(:utc)
    #fresh_when last_modified: max_updated_at, etag: @users
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted.'
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
				  :password_confirmation)
    end

    def user_info_params
      params.require(:user_info).permit(:school)
    end

    def get_total_pledged(user, auction_items)
      total_pledged = 0

      auction_items.each do |item|
        last_bid = item.bids.first
        max_bid_amount = item.max_bid
        if max_bid_amount == last_bid.amount
          total_pledged += max_bid_amount
        end
      end

      total_pledged
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
