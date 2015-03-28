class TwitterUser
  include MongoMapper::EmbeddedDocument

  belongs_to :tweet

  key :twitter_user_id, String
  key :user_screen_name, String
  key :profile_image_url, String
  key :profile_image_url_https, String
end
