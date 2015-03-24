class ApplicationUserCredential
  include MongoMapper::EmbeddedDocument

  belongs_to :application_user

  key :provider, String
  key :token, String
  key :secret, String

end
