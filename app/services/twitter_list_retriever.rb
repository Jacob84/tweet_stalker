require 'twitter_api_wrapper'

class TwitterListRetriever < TwitterApiWrapper
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
