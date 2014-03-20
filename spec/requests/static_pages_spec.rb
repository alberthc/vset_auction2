require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do

    it "should have the content 'Vset Auction'''" do
      visit '/static_pages/home'
      expect(page).to have_content('Vset Auction')
    end

    it "should have the base title" do
      visit '/static_pages/home'
      expect(page).to have_title('VSET Auction')		
    end

    it "should not have a custome page title" do
      visit '/static_pages/home'
      expect(page).not_to have_title('| Home')
    end

  end

  describe "Help" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    it "should have the title 'Help'" do
      visit '/static_pages/help'         
      expect(page).to have_title('Help')        
    end
  end

  describe "About page" do

    it "should have the content 'About VSET Auction'" do
      visit '/static_pages/about'
      expect(page).to have_content('About VSET Auction')
    end

    it "should have the title 'About'" do
      visit '/static_pages/about'         
      expect(page).to have_title('About')        
    end
  end
end
