include ApplicationHelper

module SessionsHelper

  @user_cache_expiration_time = 1.day
 
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.hash(remember_token))
    cookies.permanent[:current_user_id] = user.id
    Rails.cache.write(cache_key_for_current_user, user, expires_in: @user_cache_expiration_time)
  end

  def cache_key_for_current_user
    current_user_id = cookies[:current_user_id]
    remember_token = User.hash(cookies[:remember_token])
    if current_user_id.nil?
      new_current_user = get_new_current_user
      if new_current_user.nil?
        current_user_id = -1
      else
        current_user_id = new_current_user.id
      end
    end

    return "current_user#{current_user_id}-#{remember_token}"
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.hash(User.new_remember_token))
    cookies.delete(:remember_token)
    Rails.cache.delete(cache_key_for_current_user)
    Rails.cache.delete("current_auction")
    cookies.delete(:current_user_id)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user = cache_fetch(cache_key_for_current_user, 1.hour, method(:get_new_current_user))
  end

  def get_new_current_user
    remember_token = User.hash(cookies[:remember_token])
    User.find_by(remember_token: remember_token)
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
    cache_key = "#{cache_key_for_auctions}/current_auction"
    @current_auction = cache_fetch(cache_key, 1.hour, method(:get_new_active_auction))

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
