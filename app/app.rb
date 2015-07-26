module Alfred
  class App < Padrino::Application
    register Padrino::Rendering
    register Padrino::Mailer
    register Padrino::Helpers
    register Padrino::Admin::AccessControl

    enable :sessions
    enable :authentication
    enable :store_location
    set :allow_disabled_csrf, true

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

    # You can configure for a specified environment like:
    #
    configure :test do
      set :delivery_method, :test
    end

    configure :development do
      set :delivery_method, :file => {
        :location => "#{Padrino.root}/tmp/emails",
      }
    end

    configure :staging, :production do
      set :delivery_method, :smtp => {
        :address              => ENV['MAIL_SERVER'],
        :port                 => ENV['MAIL_PORT'],
        :user_name            => ENV['MAIL_USER'],
        :password             => ENV['MAIL_PASSWORD'],
        :authentication       => :plain,
        :enable_starttls_auto => true
      }
    end

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

    access_control.roles_for :any do |role|
      role.protect '/'
      role.allow   '/login'
      role.allow   '/register'
      role.allow   '/api'
      role.allow   '/health'
      role.allow   '/restore_password'
    end

    access_control.roles_for :teacher do |role|
      role.project_module :assignments, '/courses/.+/assignments'
      role.project_module :assignments, '/.+/gradings_report'
      role.project_module :assignment_files, '/assignment/.+/assignment_file'
      role.project_module :corrections, '/corrections'
      role.project_module :students, '/courses/.+/students'
      role.project_module :solutions, '/.+/file'
      role.project_module :my, '/courses/.+/my'
    end

    access_control.roles_for :student do |role|
      role.project_module :solutions, '/.+/file'
      role.project_module :my, '/courses/.+/my'
      role.allow '/assignment/.+/assignment_file$'
    end

    get '/' do
      render 'home/index'
    end

    get '/logout' do
      set_current_account(nil)
      set_current_course(nil)
      redirect '/'
    end

    get :login do
      render '/home/login'
    end

    post :login do
      if account = Account.authenticate(params[:email], params[:password])
        set_current_account(account)
        if account.is_student? && account.is_enrolled?(Course.active)
				  redirect_back_or_default("courses/#{current_course.name}/my/assigments")
        else
          redirect_back_or_default('/')
        end
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

    get :restore_password do
      render "/home/restore_password"
    end

    post :restore_password do
      password_generated = generate_password

      begin
        @account = Account.find_by_email(params[:account][:email])
        @account.update(password: password_generated, password_confirmation: password_generated)

        deliver(:notification, :password_has_been_reset, params[:account][:email], password_generated)

        flash[:success] = "Tu password ha sido restablecida, pronto recibiras un email con tu nueva clave."
        redirect("/login")
      rescue
        flash[:error] = "Ocurrio un error y no se pudo completar el restablecimiento de tu password, intentalo nuevamente!"
        redirect("/restore_password")
      end
    end

    post :register do
      @account = Account.new_student(params[:account])
      @account.courses << Course.active
      if @account.save
        flash[:success] = t(:account_created)
        redirect('/login')
      else
        flash.now[:error] = t(:account_creation_error)
        render 'home/register'
      end
    end

    get :course, :map => 'courses/:course_id' do
      set_current_course Course.first(:name => params[:course_id])
      render 'home/index'
    end

		def store_location
			session[:return_to] = request.url
    end

    get :teachers, :parent => :courses do
      @teachers = Course.first(:id => params[:course_id]).teachers
      render 'home/teachers'
    end

  end

end
