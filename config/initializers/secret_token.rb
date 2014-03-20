# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

#VsetAuction2::Application.config.secret_key_base = '744164cd6d28ee934fb6abbf0dfc5d862185faf1d7aec3d2546f5fad3ae0fca5961602c3a96f41d052e58e8f4800dc1dbe62d58fe4cd5483543b62d088c8d00d'

require 'securerandom'

def secure_token
  token_file = Rails.root.join('.secret')
  if File.exist?(token_file)
    # Use the existing token.
    File.read(token_file).chomp
  else
    # Generate a new token and store it in token_file.
    token = SecureRandom.hex(64)
    File.write(token_file, token)
    token
  end
end

VsetAuction2::Application.config.secret_key_base = secure_token
