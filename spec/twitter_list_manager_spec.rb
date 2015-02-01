require 'twitter_list_manager'
require 'ostruct'

LIST_ID = 1
TWEET_ID = 1000
TWEET_CREATED_AT = 'date'
TWEET_TEXT = 'text'
TWEET_FAVORITE_COUNT = 10
TWEET_RETWEET_COUNT = 20

RSpec.describe TwitterListManager do

  before do
    @client = double()
    @wrapper = TwitterListManager.new(@client)

    allow(@client).to receive(:list_timeline).and_return([get_test_tweet])
  end

  context 'when no previous tweets' do
    it 'should call without since_id' do
      @wrapper.sync_list_timeline(LIST_ID)
      expect(@client).to have_received(:list_timeline).with(LIST_ID, {})
    end

    it 'should map fields correctly' do
      tweet = Tweet.all.first
      expect(tweet.twitter_list_id).to eq LIST_ID.to_s
      expect(tweet.twitter_tweet_id).to eq TWEET_ID.to_s
      expect(tweet.text).to eq TWEET_TEXT
      expect(tweet.favorite_count).to eq TWEET_FAVORITE_COUNT
      expect(tweet.retweet_count).to eq TWEET_RETWEET_COUNT
    end
  end

  context 'when previous tweets' do
    before do
      Tweet.create({:twitter_tweet_id => '123132'})
    end

    it 'should call with since_id' do
      @wrapper.sync_list_timeline(LIST_ID)
      expect(@client).to have_received(:list_timeline).with(LIST_ID, {:since_id => '123132'})
    end

    it 'should map fields correctly' do
      tweet = Tweet.all.first
      expect(tweet.twitter_list_id).to eq LIST_ID.to_s
      expect(tweet.twitter_tweet_id).to eq TWEET_ID.to_s
      expect(tweet.text).to eq TWEET_TEXT
      expect(tweet.favorite_count).to eq TWEET_FAVORITE_COUNT
      expect(tweet.retweet_count).to eq TWEET_RETWEET_COUNT
    end
  end

  after :all do
    Tweet.destroy_all
  end

  def get_test_tweet
    tweet_hash = {
      :id => TWEET_ID,
      :created_at => TWEET_CREATED_AT,
      :text => TWEET_TEXT,
      :favorite_count => TWEET_FAVORITE_COUNT,
      :retweet_count => TWEET_RETWEET_COUNT
    }

    profile_image = {
      :scheme => 'http',
      :host => 'host',
      :path => 'path'
    }

    tweet = OpenStruct.new(tweet_hash)
    tweet.user_mentions = [OpenStruct.new({:screen_name => 'screen_name'})]
    tweet.urls = [OpenStruct.new({:url => 'url'})]
    tweet.hashtags = ['hashtag1', 'hashtag2']
    tweet.user = OpenStruct.new
    tweet.user.profile_image_url = OpenStruct.new(profile_image)
    tweet.user.profile_image_url_https = OpenStruct.new(profile_image)

    return tweet
  end

end
