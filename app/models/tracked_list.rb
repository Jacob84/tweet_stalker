class TrackedList
  include MongoMapper::Document

  key :user_id, Integer
  key :twitter_list_id, Integer
  key :tracked, Boolean
  key :uri, String
  key :name, String
  key :subscriber_count, Integer
  key :member_count, Integer
  key :mode, String

end
