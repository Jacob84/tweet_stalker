class ApplicationConfiguration
  include MongoMapper::Document

  key :key, String
  key :value, String

  ApplicationConfiguration.ensure_index [[:key, 1]], :unique => true
end
