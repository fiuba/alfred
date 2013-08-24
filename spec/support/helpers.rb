def login
	visit '/login' 
	fill_in :email, :with => "x@x.com"
	fill_in :password, :with => "foobar"
	click_button(I18n.translate('padrino.admin.login.sign_in'))
end

