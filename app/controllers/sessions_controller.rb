class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  # assign them a random one and mail it to them, asking them to change it
  def forgot_password
    @user = User.find_by_email(params[:session][:email])
    if !@user.nil?
      random_password = Array.new(10).map { (65 + rand(58)).chr }.join
      @user.password = random_password
      @user.password_confirmation = random_password
      @user.save!
      Mailer.password_reset(@user, random_password).deliver
      flash[:success] = 'Password is reset'
      render 'password_reset'
    else
      flash.now[:error] = 'Invalid email address'
      render 'password_reset'
    end
  end

  def password_change
  end

  def password_reset
  end

  def update_password
    user = User.find_by_email(params[:session][:email])
    password = params[:session][:password]
    new_password = params[:session][:new_password]
    new_password_confirmation = params[:session][:new_password_confirmation]

    if user.nil? || password.empty? || new_password.empty? || new_password_confirmation.empty?
      flash.now[:error] = 'All fields must be filled'
      render 'password_change'
    else
      user.password = password
      user.password_confirmation = password

      if user.save && new_password == new_password_confirmation
        user.password = new_password
        user.password_confirmation = new_password_confirmation
        user.save!
        flash[:success] = 'Password change successfully'
        render 'password_change'
      else
        flash.now[:error] = 'Password is incorrect or doesn\'t match'
        render 'password_change'
      end
    end
  end
end
