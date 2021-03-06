FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :auction do
    sequence(:name)  { |n| "Auction #{n}" }
    description "This is the description."
    start_time 10.days.ago
    end_time 10.days.from_now
    banner_image_path "banner_image"
    user
    
    factory :active_auction do
      active true
    end
  end

  factory :auction_item do
    name "Example Item"
    description "this is the description."
    image_path "image path"
    category 3
    min_bid 30
    min_incr 5
    user
    auction
  end
end
