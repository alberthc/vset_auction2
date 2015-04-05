class StaticPagesController < ApplicationController
  def contact
  end

  def help
  end

  def home
    if signed_in?
      if !current_auction.nil?
        redirect_to current_auction
      else
        render 'no_auction'
      end
    end
  end

  def no_auction
  end
end
