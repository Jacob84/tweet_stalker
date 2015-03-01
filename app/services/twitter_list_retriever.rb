require 'twitter_api_wrapper'

class TwitterListRetriever < TwitterApiWrapper

  def initialize(client = nil)
    super(client)
    @@cached_lists = []
  end

  def lists
    if (@@cached_lists.length == 0)
      lists = @client.lists()

      lists.each do |list|
        @@cached_lists << List.new({
          :twitter_list_id => list.id,
          :name => list.name,
          :uri => list.uri,
          :subscriber_count => list.subscriber_count,
          :member_count => list.member_count,
          :mode => list.mode
        })
      end
    end

    @@cached_lists
  end
end
