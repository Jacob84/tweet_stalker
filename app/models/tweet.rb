class Tweet
  include MongoMapper::Document

  one :twitter_user

  key :twitter_list_id, Integer
  key :twitter_tweet_id, Integer

  key :created_at, DateTime
  key :text, String
  key :user_mentions, String
  key :urls, String
  key :hashtags, String
  key :favorite_count, Integer
  key :retweet_count, Integer
  key :noun_phrases, String
  key :analyzed, Boolean

end
