class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @my_items = @user.auction_items.paginate(page: params[:page],
	per_page: 10).order('LOWER(name) ASC')
    if !@user.bids.nil?
      @bids = @user.bids.order('id DESC')

      @following_items = Array.new
      @my_bids = Array.new
      @bids.each do |bid|
	@auction_item = bid.auction_item
	if !@following_items.include? @auction_item
	  @following_items.push @auction_item
	  @my_bids.push bid
	end
      end
      @following_items

      ##
      #@total_pledged = 0
      #@my_bids.each do |bid|
      #	@total_pledged += bid.amount
      #end
    end

    @user_name_header = @user.name + "'s"
    if @user == current_user
      @user_name_header = "My"
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the VSET Auction!"
      redirect_to current_auction
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
