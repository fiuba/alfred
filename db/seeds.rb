# Seed add you the ability to populate your db.
# We provide you a basic shell for interaction with the end user.
# So try some code like below:
#
#   name = shell.ask("What's your name?")
#   shell.say name
#


course = Course.new
course.name = '2013-1'
course.active = true
course.save

teacher = Account.new_teacher({:name => 'teacher_name', 
															 :surname => 'teacher_surname',
															 :password => 'Passw0rd!',
															 :password_confirmation => 'Passw0rd!',
															 :buid => '12345', 
															 :email => 'teacher@test.com'})
teacher.courses << course
teacher.save

teacher2 = Account.new_teacher({:name => 'teacher2_name', 
															 :surname => 'teacher_surname',
															 :password => 'Passw0rd!',
															 :password_confirmation => 'Passw0rd!',
															 :buid => '123456', 
															 :email => 'teacher2@test.com'})
teacher2.courses << course
teacher2.save

student = Account.new_student({:name => 'student_name', 
															 :surname => 'student_surname',
															 :password => 'Passw0rd!',
															 :password_confirmation => 'Passw0rd!',
															 :buid => '12346',
															 :tag => 'mie',
															 :email => 'student@test.com'})
student.courses << course
student.save


email     = shell.ask "Which email do you want use for logging into admin?"
password  = shell.ask "Tell me the password to use:"

shell.say ""

account = Account.create(:email => email, :buid => "root", :name => "Foo", :surname => "Bar", :password => password, :password_confirmation => password, :role => "admin")

if account.valid?
  shell.say "================================================================="
  shell.say "Account has been successfully created, now you can login with:"
  shell.say "================================================================="
  shell.say "   email: #{email}"
  shell.say "   password: #{password}"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went wrong!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

shell.say ""
