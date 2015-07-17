module FileExceptions

  class FileNotFound < Exception

    def initialize message
      @message = message
    end

  end

end