require 'twitter_list_manager'

class WelcomeController < ApplicationController

  def index

    t = TwitterListManager.new

    t.sync_list_timeline



    # @things = Tweet.all
    #
    # @things.each do |t|
    #   t.destroy
    # end
    #
    # t = Tweet.new(
    #   :twitter_tweet_id => 'aaaahey',
    #   :created_at => DateTime.now,
    #   :text => 'text',
    #   :user_mentions => '@user1, @user2',
    #   :urls => 'url1, url2',
    #   :hashtags => '#one, #two',
    #   :favorite_count => '1',
    #   :retweet_count => '2',
    #   :noun_phrases => '3',
    #   :twitter_user => TwitterUser.new(
    #     :twitter_user_id => "hey again",
    #     :user_screen_name => "aa",
    #     :profile_image_url => "aa",
    #     :profile_image_url_https => "bb"))
    #
    # t.save

    render plain:@things

  end

end
