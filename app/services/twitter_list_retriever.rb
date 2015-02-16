class TwitterListRetriever
  def initialize(client = nil)
    @client = client
    if @client == nil
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        =  ApplicationConfiguration.find_by_key('consumer_key').value
        config.consumer_secret     =  ApplicationConfiguration.find_by_key('consumer_secret').value
        config.access_token        =  ApplicationConfiguration.find_by_key('access_token').value
        config.access_token_secret =  ApplicationConfiguration.find_by_key('access_token_secret').value
      end
    end
  end

  def lists
    result = []
    lists = @client.lists()

    lists.each do |list|
      result << List.new({
        :twitter_list_id => list.id,
        :name => list.name,
        :uri => list.uri,
        :subscriber_count => list.subscriber_count,
        :member_count => list.member_count,
        :mode => list.mode
      })
    end

    result
  end
end
