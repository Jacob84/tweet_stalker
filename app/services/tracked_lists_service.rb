class TrackedListsService
  def initialize(list_retriever = TwitterListRetriever.new)
    @list_retriever = list_retriever
  end

  def get_lists(user_id)
    twitter_lists = @list_retriever.lists
    tracked_lists = TrackedList.find_all_by_user_id(user_id)

puts twitter_lists.inspect

    twitter_lists.each do |list|
      current_tracked_list = tracked_lists.find { |x|
        x.twitter_list_id == list.list_id
      }

      if current_tracked_list.nil?
        TrackedList.create({
          :twitter_list_id => list.list_id,
          :user_id => user_id,
          :name => list.name,
          :uri => list.uri,
          :subscriber_count => list.subscriber_count,
          :member_count => list.member_count,
          :mode => list.mode,
          :tracked => false
        })
      end
    end

    return TrackedList.find_all_by_user_id(user_id)
  end

  def add_lists(user_id, list_identifiers)
    tracked_lists = TrackedList.find_all_by_user_id(user_id)

    list_identifiers.each do |identifier|
      current_tracked_list = tracked_lists.find { |x|
        x.twitter_list_id == identifier
      }

      if current_tracked_list.nil?
        current_tracked_list = TrackedList.new({
          :user_id => user_id,
          :twitter_list_id => identifier,
          :tracked => true
          })
      else
        current_tracked_list.tracked = true
      end

      current_tracked_list.save
    end
  end
end
