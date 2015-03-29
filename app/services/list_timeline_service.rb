class ListTimelineService
  def initialize(manager = TwitterListTimelineDownloader.new,
                 analyzer = TwitterListAnalyzer.new)

    @manager = manager
    @analyzer = analyzer
  end

  def get_timeline(user, twitter_list_id)
    Tweet
      .where(analyzed: true)
      .where(user_id: user._id)
      .where(twitter_list_id: twitter_list_id)
      .sort(:created_at.desc)
  end

  def update_timeline(user, twitter_list_id)
    @manager.sync_list_timeline(user, twitter_list_id)
    @analyzer.process_pending_tweets(user)
  end
end
