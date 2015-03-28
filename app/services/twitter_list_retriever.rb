require 'twitter_api_wrapper'

class TwitterListRetriever < TwitterApiWrapper

  def initialize(client = nil)
    super(client)
  end

  def lists(user)
    result = []
    lists = get_client(user).lists()

    lists.each do |list|
      result << TwitterApiList.new(
        list_id: list.id,
        name: list.name,
        uri: list.uri,
        subscriber_count: list.subscriber_count,
        member_count: list.member_count,
        mode: list.mode)
    end

    result
  end
end
