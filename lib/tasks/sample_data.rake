namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Example User",
			 email: "example@railstutorial.org",
			 password: "foobar",
			 password_confirmation: "foobar",
			 admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    auction = admin.auctions.create(start_time: 1.day.from_now,
				    end_time: 20.days.from_now,
				    name: "Example Auction",
				    description: "This is the description",
				    banner_image_path: "Banner image",
				    active: true)

    30.times do |n|
      name = "Product #{n+1}"
      description = "This is the description for #{n+1}"
      image_path = "image_path"
      category = (n%7)+1
      min_bid = 100+n
      min_incr = n+1
      admin.auction_items.create(name: name,
				 description: description,
				 image_path: image_path,
				 category: category,
				 min_bid: min_bid,
				 min_incr: min_incr,
				 auction_id: auction.id)
    end
  end
end
