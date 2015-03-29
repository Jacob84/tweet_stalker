class Tweet
  include MongoMapper::Document

  one :twitter_user
  many :noun_phrases

  key :user_id, ObjectId
  key :twitter_list_id, Integer
  key :twitter_tweet_id, Integer

  key :created_at, DateTime
  key :text, String
  key :user_mentions, String
  key :urls, String
  key :hashtags, String
  key :favorite_count, Integer
  key :retweet_count, Integer
  key :analyzed, Boolean
end
