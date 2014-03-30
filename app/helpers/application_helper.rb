module ApplicationHelper

  #Returns the full title on a per-page basis
  def full_title(page_title)
    base_title = "VSET Auction"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

#  def current_auction
#    @current_auction = nil
#    for auction in Auction.all
#      if auction.active?
#        @current_auction = auction
#        break
#      end
#    end
#  end

end
