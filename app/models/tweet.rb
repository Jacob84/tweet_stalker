class Tweet
  include MongoMapper::Document

  one :twitter_user

  key :twitter_tweet_id, String
  key :created_at, DateTime
  key :text, String
  key :user_mentions, String
  key :urls, String
  key :hashtags, String
  key :favorite_count, String
  key :retweet_count, String
  key :noun_phrases, String

end
