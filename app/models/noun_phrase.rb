class NounPhrase
  include MongoMapper::EmbeddedDocument

  belongs_to :tweet

  key :value, String
  key :points, Integer
end
