Twitter.configure do |config|
  config.consumer_key = ENV['CANTYSHANTY_TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['CANTYSHANTY_TWITTER_CONSUMER_SECRET']
  config.oauth_token = ENV['CANTYSHANTY_TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['CANTYSHANTY_TWITTER_OAUTH_SECRET']
end
