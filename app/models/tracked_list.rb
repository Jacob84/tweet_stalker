class TrackedList
  include MongoMapper::Document

  key :user_id, Integer
  key :twitter_list_id, Integer
  key :tracked, Boolean

end
