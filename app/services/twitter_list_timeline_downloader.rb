class TwitterListTimelineDownloader

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

  def sync_list_timeline(list_id)
    last_tweet = Tweet.all(:order => :created_at.desc).first

    since_id = last_tweet != nil ? last_tweet.twitter_tweet_id : nil
    since_id_hash = since_id != nil ? { :since_id => since_id } : {}

    tweets = @client
      .list_timeline(list_id, since_id_hash)
      .collect
      .take(200)

    tweets.each do |t|
      user_mentions = t.user_mentions.map { |m| m.screen_name }.join('|')
      urls = t.urls.map { |u| u.expanded_url }.join('|')
      hashtags = t.hashtags.map { |h| h }.join('|')
      profile_image_url = "#{t.user.profile_image_url.scheme}://#{t.user.profile_image_url.host}#{t.user.profile_image_url.path}"
      profile_image_url_https = "#{t.user.profile_image_url_https.scheme}://#{t.user.profile_image_url_https.host}#{t.user.profile_image_url_https.path}"

      persisted_tweet = Tweet.create(
          :twitter_list_id => list_id,
          :twitter_tweet_id => t.id,
          :created_at => t.created_at,
          :text => t.text,
          :user_mentions => user_mentions,
          :urls => urls,
          :hashtags => hashtags,
          :favorite_count => t.favorite_count,
          :retweet_count => t.retweet_count,
          :noun_phrases => '',
          :analyzed => false,
          :twitter_user => TwitterUser.new(
            :twitter_user_id => t.user.id,
            :user_screen_name => t.user.screen_name,
            :profile_image_url => profile_image_url,
            :profile_image_url_https => profile_image_url_https
          )
        )
    end
  end
end
