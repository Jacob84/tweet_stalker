class UserListsTracker
  def initialize(list_retriever = TwitterListRetriever.new)
    @list_retriever = list_retriever
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

  def get_lists(user_id)
    result = []

    twitter_lists = @list_retriever.lists
    tracked_lists = TrackedList.find_all_by_user_id(user_id)

    twitter_lists.each do |list|

      current_tracked_list = tracked_lists.find { |x|
        x.twitter_list_id == list.list_id
      }

      if !current_tracked_list.nil?
        result << decorate_list(current_tracked_list, list, true)
      else
        new_tracked_list = TrackedList.new({
          :user_id => user_id,
          :twitter_list_id => list.list_id
        })

        result << decorate_list(new_tracked_list, list, false)
      end
    end

    return result
  end

  private

  def decorate_list(tracked_list, twitter_list, tracked)
    return TrackedList.new({
      :user_id => tracked_list.user_id,
      :twitter_list_id => tracked_list.twitter_list_id,
      :name => twitter_list.name,
      :mode => twitter_list.mode,
      :member_count => twitter_list.member_count,
      :subscriber_count => twitter_list.subscriber_count,
      :tracked => tracked
    })
  end

end
