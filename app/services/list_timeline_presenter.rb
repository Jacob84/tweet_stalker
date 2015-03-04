class ListTimelinePresenter

  def get_timeline(user_id, twitter_list_id)
    Tweet
          .where(:analyzed => true)
          .where(:user_id => user_id)
          .where(:twitter_list_id => twitter_list_id)
          .sort(:created_at.desc)
  end

end
