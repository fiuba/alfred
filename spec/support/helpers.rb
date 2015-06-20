def login
	visit '/login' 
	fill_in :email, :with => "x@x.com"
	fill_in :password, :with => "foobar"
	click_button(I18n.translate('padrino.admin.login.sign_in'))
end

def simple_file name, content
	file = File.new(name, "w")
	file.puts(content)
	file.close

	file
end