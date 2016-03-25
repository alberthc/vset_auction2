module SessionsHelper

  @user_cache_expiration_time = 1.day
 
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.hash(remember_token))
    Rails.cache.write("current_user", user, expires_in: @user_cache_expiration_time)
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.hash(User.new_remember_token))
    cookies.delete(:remember_token)
    Rails.cache.delete("current_user")
    Rails.cache.delete("current_auction")
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    puts "current_user ------------------------------------- 1"
    remember_token = User.hash(cookies[:remember_token])
    @current_user = Rails.cache.fetch("current_user", expires_in: @user_cache_expiration_time) do
    puts "current_user NEW ------------------------------------- 1"
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
    expiration_time = 60.days
    if is_auction_dirty?
      puts "CURRENT_AUCTION DIRTY -------------------------------------- 1"
      @current_auction = get_new_active_auction
      Rails.cache.write("current_auction", @current_auction, expires_in: expiration_time)
    else
      puts "CURRENT_AUCTION -------------------------------------- 2"
      @current_auction = Rails.cache.fetch("current_auction", expires_in: expiration_time) do
        puts "CURRENT_AUCTION NEW -------------------------------------- 2"
        get_new_active_auction
      end
    end

    return @current_auction
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

  def is_auction_dirty?
    is_auction_dirty_cookie = cookies[:is_auction_dirty]

    if (is_auction_dirty_cookie.nil? || is_auction_dirty_cookie == "true")
      cookies.permanent[:is_auction_dirty] = "false"
      return true
    end

    return false
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
