class Account
  include DataMapper::Resource
  include DataMapper::Validate
  attr_accessor :password, :password_confirmation

  # Available roles
  TEACHER = 'teacher'
  STUDENT = 'student'
  ADMIN = 'admin'

  # Properties
  property :id,               Serial
  property :name,             String
  property :surname,          String
  property :buid,             String
  property :email,            String
  property :crypted_password, String, :length => 70
  property :role,             String
  property :tag,             String
  has n, :courses, :through => Resource

  # Validations
  validates_presence_of      :email, :role, :buid
  validates_presence_of      :password,                          :if => :password_required
  validates_presence_of      :password_confirmation,             :if => :password_required
  validates_length_of        :password, :min => 4, :max => 40,   :if => :password_required
  validates_confirmation_of  :password,                          :if => :password_required
  validates_length_of        :email,    :min => 3, :max => 100
  validates_uniqueness_of    :email,    :case_sensitive => false
  validates_uniqueness_of    :buid,    :case_sensitive => false
  validates_format_of        :email,    :with => :email_address
  validates_format_of        :role,     :with => /[A-Za-z]/

  # Callbacks
  before :save, :encrypt_password

  ##
  # This method is for authentication purpose
  #
  def self.authenticate(email, password)
    account = first(:conditions => { :email => email }) if email.present?
    account && account.has_password?(password) ? account : nil
  end

  ##
  # This method is used by AuthenticationHelper
  #
  def self.find_by_id(id)
    get(id) rescue nil
  end

  def self.new_student(params)
    account = Account.new(params)
    account.role = STUDENT 
    account
  end

  def self.new_teacher(params)
    account = Account.new(params)
    account.role = TEACHER
    account
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  def is_student?
    @role == STUDENT
  end

  def is_teacher?
    self.role == TEACHER
  end

  def self.available_roles
    return [ STUDENT, TEACHER, ADMIN ]
  end

  def status_for_assignment(assignment)
    solutions = Solution.find_by_account_and_assignment(self, assignment)        
    assignment_status = AssignmentStatus.new 
    assignment_status.name = assignment.name
    if solutions.nil?
      assignment_status.status = :solution_pending 
      assignment_status.solution_count = 0
      #assignment_status.latest_solution_date = nil
      return assignment_status
    end
    solutions.sort_by! { |s| s.created_at}
    assignment_status.solution_count = solutions.size
    assignment_status.status = :correction_pending
    assignment_status.latest_solution_date = solutions.last.created_at
    solutions.each do | s |
      if s.correction
        if s.correction.approved?
          assignment_status.status = :correction_passed
          return assignment_status
        end
        assignment_status.status = :correction_failed
      end
    end
    assignment_status
  end
  
  private
  def password_required
    crypted_password.blank? || password.present?
  end

  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password) if password.present?
  end

end
