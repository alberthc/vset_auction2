require 'spec_helper'

describe AuctionItem do

  let(:user) { FactoryGirl.create(:user) }

  before do
    @auction = user.auctions.build(name: "Example Auction", description: "This 
        is the description", start_time: 10.days.ago, end_time: 10.days.from_now,
        banner_image_path: "banner_path", active: true)
    @auction.save

    @auction_item = user.auction_items.build(name: "Example clothing", description: "This
      is the description", image_path: "image_path_ex", category: 2, min_bid: 10,
      min_incr: 5)

    @auction_item.auction_id = @auction.id
  end

  subject { @auction_item }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:image_path) }
  it { should respond_to(:category) }
  it { should respond_to(:min_bid) }
  it { should respond_to(:min_incr) }
  it { should respond_to(:user) }
  it { should respond_to(:auction) }

  its(:user) { should eq user }
  its(:auction) { should eq @auction }

  it { should be_valid }

  describe "when user id is not present" do
    before { @auction_item.user_id = nil }
    it { should_not be_valid }
  end

  describe "when auction id is not present" do
    before { @auction_item.auction_id = nil }
    it { should_not be_valid }
  end

end
