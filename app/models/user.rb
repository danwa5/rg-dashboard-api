class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  has_secure_password

  field :uid, type: String, default: SecureRandom.uuid
  field :name, type: String
  field :email, type: String
  field :password_digest, type: String

  has_many :watchlists

  validates_presence_of :uid, :email
end
