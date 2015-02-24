class TwitterApiWrapper
  def initialize(client = nil)
    @client = client

    consumer_key = ApplicationConfiguration.find_by_key('consumer_key')
    consumer_secret = ApplicationConfiguration.find_by_key('consumer_secret')
    access_token = ApplicationConfiguration.find_by_key('access_token')
    access_token_secret = ApplicationConfiguration.find_by_key('access_token_secret')

    if consumer_key.nil?
      raise "Consumer key is missing in configuration"
    end

    if consumer_secret.nil?
      raise "Consumer secret is missing in configuration"
    end

    if access_token.nil?
      raise "Access token is missing in configuration"
    end

    if access_token_secret.nil?
      raise "Acess token secret is missing in configuration"
    end

    if @client == nil
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        =  consumer_key.value
        config.consumer_secret     =  consumer_secret.value
        config.access_token        =  access_token.value
        config.access_token_secret =  access_token_secret.value
      end
    end
  end
end
