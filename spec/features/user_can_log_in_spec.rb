require "spec_helper"

describe "a user visits the sign in page" do
  describe "and enters valid credentials" do
    let(:email){ "lawson.kurtz@viget.com" }
    let(:password){ "12345" }

    let!(:user){ FactoryGirl.create(:user, :email => email,
                        :password => password, :password_confirmation => password) }

    it "renders the account page" do
      visit "/session/new"

      fill_in "Email", :with => email
      fill_in "Password", :with => password

      click_button "Sign in"

      page.current_path.should == root_path
    end
  end

  describe "and enters invalid credentials" do
    it "re-renders the form with errors" do 
      visit "/session/new"

      fill_in "Email", :with => "blue@devils.bsktbll"
      fill_in "Password", :with => "#winning"

      click_button "Sign in"

      page.should have_content "Couldn't locate a user with those credentials"
    end
  end
end
