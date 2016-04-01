module AuctionsHelper

  def calculate_stats
    @auction_items = @auction.auction_items.includes(:bids).where(auction_id: current_auction.id).order('bids.id ASC')

    @total_pledged = 0
    @total_unpledged = 0
    # TODO: fix this later - don't hardcode school totals
    @total_USC = 0
    @total_UCLA = 0
    @total_UCI = 0
    @total_OTHER = 0
    for auction_item in @auction_items
      max_bid = auction_item.max_bid
      if !max_bid.nil?
        @total_pledged += max_bid

        user = auction_item.bids.last.user
        school = user.user_info.school
        case school
        when UserInfo::USC
          @total_USC += max_bid
        when UserInfo::UCLA
          @total_UCLA += max_bid
        when UserInfo::UCI
          @total_UCI += max_bid
        when UserInfo::OTHER
          @total_OTHER += max_bid
        else
          puts "Warning: Attempting to calculate invalid school " + school
        end
      else
        @total_unpledged += auction_item.min_bid
      end
    end
  end

end
