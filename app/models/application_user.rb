class ApplicationUser
  include MongoMapper::Document
  
  many :application_user_credentials

  key :name, String
  key :nickname, String
  key :location, String
  key :image, String
  key :description, String
end
