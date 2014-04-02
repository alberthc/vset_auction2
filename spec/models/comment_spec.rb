require 'spec_helper'

describe Comment do

  let(:user) { FactoryGirl.create(:user) }
  let(:auction_item) { FactoryGirl.create(:auction_item) }
  before do
    @comment = user.comments.build(content: "This is a comment")
    @comment.auction_item = auction_item
  end

  subject { @comment }

  it { should respond_to(:content) }
  it { should respond_to(:user) }
  it { should respond_to(:auction_item) }
  its(:user) { should eq user }
  its(:auction_item) { should eq auction_item }

  it { should be_valid }

end
