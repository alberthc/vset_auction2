require 'spec_helper'
  
describe "AuctionPages" do 

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
 
  before { admin.save }
 
  let(:auction) { FactoryGirl.create(:active_auction, user: admin) }

  before (:each) do
    sign_in user
    visit users_path
  end

  describe "header links" do
    
    it { should_not have_link('Auctions') } 

    describe "as admin user" do
      before do
	sign_in admin
	visit users_path
      end

      it { should have_link('Auctions') }
    end

  end

  # tests for admin users

  describe "index" do

    it { should_not have_link('Auctions') }

    describe "as admin user" do
      before do
        sign_in admin
        visit auctions_path
      end

      it { should have_link('Auctions') }

      it { should have_content('All Auctions') }
    end
  end

  describe "create auction" do
    before do
      visit new_auction_path
    end

    it { should_not have_content('Create Auction') }

    describe "as admin user" do
      before do
        sign_in admin
        visit new_auction_path
      end

      let(:submit) { "Create auction" }

      it { should have_content('Create Auction') }

      describe "with invalid information" do
	it "should not create an auction" do
	  expect { click_button submit }.not_to change(Auction, :count)
	end
      end
    end 
  end

  describe "delete auction" do
    it { should_not have_link('Auctions') }

    describe "as admin user" do

    end
  end

  describe "edit auction" do
    it { should_not have_link('Auctions') }

    describe "as admin user" do

    end
  end

end
