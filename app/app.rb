module Alfred
  class App < Padrino::Application
    register Padrino::Rendering
    register Padrino::Mailer
    register Padrino::Helpers
    register Padrino::Admin::AccessControl

    enable :sessions

    ##
    # Caching support
    #
    # register Padrino::Cache
    # enable :caching
    #
    # You can customize caching store engines:
    #
    # set :cache, Padrino::Cache::Store::Memcache.new(::Memcached.new('127.0.0.1:11211', :exception_retry_limit => 1))
    # set :cache, Padrino::Cache::Store::Memcache.new(::Dalli::Client.new('127.0.0.1:11211', :exception_retry_limit => 1))
    # set :cache, Padrino::Cache::Store::Redis.new(::Redis.new(:host => '127.0.0.1', :port => 6379, :db => 0))
    # set :cache, Padrino::Cache::Store::Memory.new(50)
    # set :cache, Padrino::Cache::Store::File.new(Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
    #

    ##
    # Application configuration options
    #
    # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
    # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, 'foo/bar' # Location for static assets (default root/public)
    # set :reload, false            # Reload application files (default in development)
    # set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, 'bar'       # Set path for I18n translations (default your_app/locales)
    # disable :sessions             # Disabled sessions by default (enable if needed)
    # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    ##
    # You can configure for a specified environment like:
    #
    #   configure :development do
    #     set :foo, :bar
    #     disable :asset_stamp # no asset timestamping for dev
    #   end
    #

    ##
    # You can manage errors like:
    #
    #   error 404 do
    #     render 'errors/404'
    #   end
    #
    #   error 505 do
    #     render 'errors/505'
    #   end
    #

    #set :allow_disabled_csrf, true
      
    set :login_page, "/login"

=begin
    access_control.roles_for :any do |role|
      role.protect '/solutions'
    end
=end

    get '/' do
      render 'home/index'      
    end


    get '/logout' do
      set_current_account(nil)
      redirect '/'      
    end

    get :login do
      render '/home/login'
    end

    post :login do
      if account = Account.authenticate(params[:email], params[:password])
        set_current_account(account)
        if account.is_student?
				  redirect_back_or_default("courses/#{current_course.name}/students/me")
        else
          redirect_back_or_default('/')
        end

      #elsif Padrino.env == :development && params[:bypass]
      #  account = Account.first
      #  set_current_account(account)
      #  redirect url(:base, :index)
      else
        params[:email], params[:password] = h(params[:email]), h(params[:password])
        flash[:error] = pat('login.error')
        redirect url(:login)
      end
    end

    get :register do
      @title = pat(:new_title, :model => 'account')
      @account = Account.new
      render 'home/register'
    end

    post :register do
      @account = Account.new_student(params[:account])
      @account.courses << Course.active
      if @account.save
        flash[:success] = t(:account_created)
        redirect('/login')
      else
        flash.now[:error] = pat(:create_error, :model => 'account')
        render 'home/register'
      end
    end

		def store_location
			session[:return_to] = request.url
		end
  end
end
