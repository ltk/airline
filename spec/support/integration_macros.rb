module IntegrationMacros
  def log_in(user)
    visit("/session/new")
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "password"
    click_button "Sign in"
  end
end
