require_relative '../rails_helper'

describe "Home page", :type => :feature do

  it "shows the devise registration form for new users with all of the fields empty" do
    visit "/"
    expect(all('form.new_user').count).to be(1)
    within("section.signup") do
      expect(find('input#user_email').text).to eq('')
      expect(find('input#user_plate').text).to eq('')
      expect(find('input#user_password').text).to eq('')
      expect(find('input#user_password_confirmation').text).to eq('')         
    end
  end

  it "shows the devise log in form with all of the fields empty" do
    visit "/"
    expect(find("section.login").all('form.new_session').count).to be(1)
    within("section.login") do
      expect(find('input#user_plate').text).to eq('')
      expect(find('input#user_password').text).to eq('')
    end
  end

end