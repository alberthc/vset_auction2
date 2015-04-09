class Mailer < ApplicationMailer
  def password_reset(user, new_password)
    @user = user
    @new_password = new_password
    mail(to: @user.email, subject: 'VSET Auction Password Reset')
  end
end
