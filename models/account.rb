class Account
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :email, String
  property :uid, String
  property :provider, String

  def friendly_name
    name.nil? ? uid : name
  end

  def self.create_with_omniauth(auth)
    account = Account.new
    account.provider = auth["provider"]
    account.uid      = auth["uid"]
    account.name = auth["info"]["nickname"] # warn: this is for twitter
    account.save
    account
  end
end
