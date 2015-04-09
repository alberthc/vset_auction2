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
    random_password = Array.new(10).map { (65 + rand(58)).chr }.join
    @user.password = random_password
    @user.password_confirmation = random_password
    @user.save!
    Mailer.password_reset(@user, random_password).deliver
    redirect_to password_reset_path
  end
end
