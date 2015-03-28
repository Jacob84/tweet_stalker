# TwitterApiWrapper
class TwitterApiWrapper
  def initialize(client = nil)
    @client = client
  end

  def get_client(user)
    consumer_key = ApplicationConfiguration.find_by_key('consumer_key')
    consumer_secret = ApplicationConfiguration.find_by_key('consumer_secret')

    fail 'Consumer key is missing in configuration' if consumer_key.nil?
    fail 'Consumer secret is missing in configuration' if consumer_secret.nil?

    return @client unless @client.nil?

    @client = create_client consumer_key.value, consumer_secret.value, user
  end

  private

  def create_client(consumer_key, consumer_secret, user)
    Twitter::REST::Client.new do |config|
      config.consumer_key        =  consumer_key
      config.consumer_secret     =  consumer_secret
      config.access_token        =  user.application_user_credentials.first.token
      config.access_token_secret =  user.application_user_credentials.first.secret
    end
  end
end
