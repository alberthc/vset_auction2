class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def new
    @user = User.new
    @user_info = UserInfo.new
  end

  def show
    @user = User.find(params[:id])
    @user_info = @user.user_info

    if @user_info.nil?
      @user_info = UserInfo.new
    end

    if !@user.auction_items.nil?
      @my_items = @user.auction_items.paginate(page: params[:page], per_page: 10).where(auction_id: current_auction.id).order('LOWER(name) ASC')
    end

    if !@user.bids.nil?
      @bids = @user.bids.order('id DESC')

      # Following items are AuctionItems that the user has bid on 
      @following_items = Array.new
      @my_bids = Array.new
      @bids.each do |bid|
        @auction_item = bid.auction_item
        if @auction_item.auction_id == current_auction.id
          if !@following_items.include? @auction_item
            @following_items.push @auction_item
            @my_bids.push bid
          end
        end
      end

      @total_pledged = 0

      if !@following_items.nil? && !@following_items.empty?
        @following_items.each do |auction_item|
          if !auction_item.nil? && !auction_item.bids.first.nil?
            if auction_item.bids.last.user == @user
              @total_pledged += auction_item.max_bid
            end
          end
        end
      end
    end

    @user_name_header = @user.name + "'s"
    if @user == current_user
      @user_name_header = "My"
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
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
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
