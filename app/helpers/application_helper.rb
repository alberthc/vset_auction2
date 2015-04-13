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

  # abs or /abs -> http://myx.com/abs
  # http://grosser.it/2008/11/24/rails-transform-path-to-url
  def path_to_url(path)
    "#{request.protocol}#{request.host_with_port.sub(/:80$/,"")}/#{path.sub}"
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
