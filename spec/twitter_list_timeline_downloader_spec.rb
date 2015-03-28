require 'rails_helper'
require 'ostruct'

LIST_ID = 1
USER_ID = 1
TWEET_ID = 1000
TWEET_CREATED_AT = 'date'
TWEET_TEXT = 'text'
TWEET_FAVORITE_COUNT = 10
TWEET_RETWEET_COUNT = 20

RSpec.describe TwitterListTimelineDownloader do
  let(:client) { double }

  let(:wrapper) {
    allow(client).to receive(:list_timeline).and_return([test_tweet])
    TwitterListTimelineDownloader.new(client)
  }

  let(:user) { ApplicationUser.new(_id: 1) }

  describe 'when no previous tweets' do
    before do
      wrapper.sync_list_timeline(user, LIST_ID)
    end

    it 'should call without since_id' do
      expect(client).to have_received(:list_timeline).with(LIST_ID, {})
    end

    it 'should map fields correctly' do
      tweet = Tweet.all.first
      expect(tweet.user_id).to eq USER_ID
      expect(tweet.twitter_list_id).to eq LIST_ID
      expect(tweet.twitter_tweet_id).to eq TWEET_ID
      expect(tweet.text).to eq TWEET_TEXT
      expect(tweet.favorite_count).to eq TWEET_FAVORITE_COUNT
      expect(tweet.retweet_count).to eq TWEET_RETWEET_COUNT
    end
  end

  describe 'when previous tweets' do
    before do
      Tweet.create({
        user_id: USER_ID,
        twitter_list_id: LIST_ID,
        twitter_tweet_id: TWEET_ID })

      wrapper.sync_list_timeline(user, LIST_ID)
    end

    it 'should call with since_id' do
      expect(client).to have_received(:list_timeline).with(USER_ID, since_id: TWEET_ID)
    end

    it 'should map fields correctly' do
      tweet = Tweet.all.first
      expect(tweet.user_id).to eq USER_ID
      expect(tweet.twitter_list_id).to eq LIST_ID
      expect(tweet.twitter_tweet_id).to eq TWEET_ID
    end
  end

  after :each do
    Tweet.destroy_all
  end

  def test_tweet
    tweet_hash = {
      id: TWEET_ID,
      created_at: TWEET_CREATED_AT,
      text: TWEET_TEXT,
      favorite_count: TWEET_FAVORITE_COUNT,
      retweet_count: TWEET_RETWEET_COUNT
    }

    profile_image = {
      scheme: 'http',
      host: 'host',
      path: 'path'
    }

    tweet = OpenStruct.new(tweet_hash)
    tweet.user_mentions = [OpenStruct.new(screen_name: 'screen_name')]
    tweet.urls = [OpenStruct.new(url: 'url')]
    tweet.hashtags = %w(hashtag1, hashtag2)
    tweet.user = OpenStruct.new
    tweet.user.profile_image_url = OpenStruct.new(profile_image)
    tweet.user.profile_image_url_https = OpenStruct.new(profile_image)

    tweet
  end
end
