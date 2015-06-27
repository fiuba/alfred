Alfred::App.helpers do

  def gravatar_url
    gravatar_url_for current_account.email
  end

  def gravatar_url_for email
    hash = gravatar_hash_for email
    "http://www.gravatar.com/avatar/#{hash}"
  end

  def generate_password
    SecureRandom.hex(40)
  end

  private
  def gravatar_hash_for email
    Digest::MD5.hexdigest(email.delete(" ").downcase)
  end

end