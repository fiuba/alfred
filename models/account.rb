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
  has n, :solutions

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

  validates_with_method :tag, :method => :is_valid_tag?

  after :create do
    if self.role == ADMIN || self.role == TEACHER
      # Associate all Courses with Teacher / Admin
      Course.all.each do |c|
        self.courses << c
      end
    elsif Course.active
      self.courses << Course.active
    end

    self.save
  end

  def is_valid_tag?
    return true unless self.is_student?

    if Account.valid_tags.include? @tag
      return true
    end
    errors.add(:tag, "Debe ser mie, jt o jn")
    return false
  end

  def self.valid_tags
    ['mie', 'jt', 'jn']
  end

  # Callbacks
  before :save, :encrypt_password

  ##
  # This method is for authentication purpose
  #
  def self.authenticate(email, password)
    account = first(:conditions => { :email => email }) if email.present?
    account && account.has_password?(password) ? account : nil
  end

  def self.find_by_buid(buid)
    account = first(:conditions => { :buid => buid })
  end


  ##
  # This method is used by AuthenticationHelper
  #
  def self.find_by_id(id)
    get(id) rescue nil
  end

  def self.find_by_roles(roles)
    self.all(role: roles)
  end

  def self.new_student(params)
    new_account_with_role params, STUDENT
  end

  def self.new_teacher(params)
    new_account_with_role params, TEACHER
  end

  def self.new_admin(params)
    new_account_with_role params, ADMIN
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
    solutions = Solution.all(:account => self, :assignment => assignment)
    assignment_status = AssignmentStatus.new
    assignment_status.assignment_id = assignment.id
    assignment_status.name = assignment.name
    assignment_status.deadline = assignment.deadline
    if solutions.empty?
      assignment_status.status = :solution_pending
      assignment_status.solution_count = 0
      return assignment_status
    end
    solutions.sort_by! { |s| s.created_at}
    assignment_status.solution_count = solutions.size
    assignment_status.status = :correction_pending
    assignment_status.latest_solution_date = solutions.last.created_at
    solutions.each do | s |
      if s.correction
        assignment_status.corrector_name = s.correction.teacher.full_name
        assignment_status.status = s.correction.status
      end
    end
    assignment_status
  end

  def full_name
    "#{self.name} #{self.surname}"
  end

  def prety_full_name
    "#{self.surname}, #{self.name}"
  end

  private
  def password_required
    crypted_password.blank? || password.present?
  end

  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password) if password.present?
  end

  def self.new_account_with_role(params, role)
    account = Account.new(params)
    account.role = role
    account
  end

end
