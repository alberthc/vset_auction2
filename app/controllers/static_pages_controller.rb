class StaticPagesController < ApplicationController
  def home
    if signed_in?
      redirect_to current_auction
    end
  end

  def help
  end

  def help
  end

  def contact
  end
end
