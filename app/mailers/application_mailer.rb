class ApplicationMailer < ActionMailer::Base
  default from: 'vsetauctionmail@gmail.com'
  layout 'mailer'

  def path_to_url(path)
    "#{root_url}#{path}"
  end

end
