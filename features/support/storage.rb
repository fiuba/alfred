# Taken from the cucumber-rails project.

module StorageHelpers
  def self.set_up_environment
    ENV['DROPBOX_APP_KEY']='12345abcde'                                                                                                                                                   
    ENV['DROPBOX_APP_SECRET']='12345abcde'
    ENV['DROPBOX_REQUEST_TOKEN_KEY']='12345abcde'
    ENV['DROPBOX_REQUEST_TOKEN_SECRET']='12345abcde'
    ENV['DROPBOX_AUTH_TOKEN_KEY']='12345abcde'
    ENV['DROPBOX_AUTH_TOKEN_SECRET']='12345abcde'
  end
end
