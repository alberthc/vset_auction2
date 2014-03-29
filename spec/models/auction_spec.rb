require 'spec_helper'

describe Auction do

  let(:user) { FactoryGirl.create(:user) }

  before do
    @auction = user.auctions.build(name: "Example Auction", description: "This 
	is the description", start_time: 10.days.ago, end_time: 10.days.from_now,
	banner_image_path: "banner_path", active: true)
  end

  subject { @auction }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:start_time) }
  it { should respond_to(:end_time) }
  it { should respond_to(:banner_image_path) }
  it { should respond_to(:active) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user id is not present" do
    before { @auction.user_id = nil }
    it { should_not be_valid }
  end

  describe "only one auction should be valid" do

  end

end
