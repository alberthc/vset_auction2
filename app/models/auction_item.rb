class AuctionItem < ActiveRecord::Base
  belongs_to :auction
  has_many :bids
  belongs_to :user
  has_many :comments

  validates :user_id, presence: true
  validates :auction_id, presence: true 
  validates :min_bid, numericality: { only_integer: true}
  validates :min_incr, numericality: { only_integer: true, greater_than: 0 }

  # This method associates the attribute ":image" with a file attachment
  if Rails.env.production?
    has_attached_file :image, styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
    },
    :default_url => '/images/:attachment/missing_:style.jpg'
  else
    has_attached_file :image,
      styles: {
	thumb: '100x100>',
	square: '200x200#',
	medium: '300x300>'
      },
      :default_url => '/assets/missing_:style.jpg',
      :storage => :s3,
      :bucket => S3_BUCKET_NAME,
      :s3_credentials => {
	:access_key_id => AWS_ACCESS_KEY_ID,
	:secret_access_key => AWS_SECRET_ACCESS_KEY
      },
      :url =>':s3_domain_url',
      :path => '/:class/:attachment/:id_partition/:style/:filename'
  end
  
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  # Constants

  ALL = 0
  BOOK = 1
  CLOTHING = 2
  FOOD = 3
  MUSIC = 4
  SERVICE = 5
  TECHNOLOGY = 6
  OTHER = 7
end
