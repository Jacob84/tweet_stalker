class TrackedListsService
  def initialize(list_retriever = TwitterListRetriever.new)
    @list_retriever = list_retriever
  end

  def get_lists(user)
    twitter_lists = @list_retriever.lists(user)

    tracked_lists = TrackedList.find_all_by_user_id(user._id)

    twitter_lists.each do |list|
      current_tracked_list = tracked_lists.find { |x| x.twitter_list_id == list.list_id }

      next unless current_tracked_list.nil?

      TrackedList.create(
        twitter_list_id: list.list_id,
        user_id: user._id,
        name: list.name,
        uri: list.uri,
        subscriber_count: list.subscriber_count,
        member_count: list.member_count,
        mode: list.mode,
        tracked: false)
    end

    TrackedList.find_all_by_user_id(user._id)
  end

  def add_lists(user, list_identifiers)
    tracked_lists = TrackedList.find_all_by_user_id(user._id)

    list_identifiers.each do |list|
      current_tracked_list = tracked_lists.find { |x| x.twitter_list_id == list[:id] }

      if current_tracked_list.nil?
        current_tracked_list = TrackedList.new(
          user_id: user._id,
          twitter_list_id: list[:id],
          tracked: list[:tracked])
      else
        current_tracked_list.tracked = list[:tracked]
      end

      current_tracked_list.save
    end
  end
end
