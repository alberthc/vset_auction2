class Mailer < ApplicationMailer
  def password_reset(user, new_password)
    @user = user
    @new_password = new_password
    @url = password_change_path
    mail(to: @user.email, subject: 'VSET Auction Password Reset')
  end
end
