class ApplicationMailer < ActionMailer::Base
  default from: 'vsetauctionmailer@gmail.com'
  layout 'mailer'

  def path_to_url(path)
    "#{root_url}#{path}"
  end

end
