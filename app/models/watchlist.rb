class Watchlist
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uid, type: String, default: SecureRandom.uuid
  field :name, type: String
  field :stocks, type: Array

  belongs_to :user

  validates_presence_of :uid, :name, :user
  validates :name, uniqueness: { scope: :user }
end
