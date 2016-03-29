module SessionsHelper

  @user_cache_expiration_time = 1.day
 
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.hash(remember_token))
    cookies.permanent[:current_user_id] = user.id
    Rails.cache.write(current_user_cache_key, user, expires_in: @user_cache_expiration_time)
  end

  def current_user_cache_key
    current_user_id = cookies[:current_user_id]
    if current_user_id.nil?
      return "current_user"
    end

    return "current_user#{current_user_id}"
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.hash(User.new_remember_token))
    cookies.delete(:remember_token)
    Rails.cache.delete(current_user_cache_key)
    Rails.cache.delete("current_auction")
    cookies.delete(:current_user_id)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.hash(cookies[:remember_token])
    @current_user = Rails.cache.fetch(current_user_cache_key, expires_in: @user_cache_expiration_time) do
      User.find_by(remember_token: remember_token)
    end
  end

  def current_user?(user)
    user == current_user
  end

  def admin_user?
    current_user.admin?
  end

  def current_auction=(auction)
    @current_auction = auction
  end

  def current_auction
    # TODO: Change this to be dynamic - retrieved from duration of current auction

    @current_auction = Rails.cache.fetch("#{cache_key_for_auctions}/current_auction") do
      get_new_active_auction
    end

    return @current_auction
  end

  def cache_key_for_auctions
    count = Auction.count
    max_updated_at = Auction.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "auctions/all-#{count}-#{max_updated_at}"
  end

  def get_new_active_auction
    new_active_auction = nil

    Auction.all.to_a.each do |auction|
      if auction.active?
        new_active_auction = auction
        break
      end 
    end

    return new_active_auction
  end

  def set_auction_dirty
    cookies.permanent[:is_auction_dirty] = "true"
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end
