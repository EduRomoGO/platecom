require_relative '../rails_helper'

describe "User public issues page", :type => :feature do

  let(:u) {User.create(:email => 'a@a.a',
              :password => '11111111',
              :plate => '1234AAA')}

  let(:user_aux1) {User.create(:email => 'b@b.b',
                       :password => '11111111',
                       :plate => '1234BBB')}
  let(:user_aux2) {User.create(:email => 'c@c.c',
                       :password => '11111111',
                       :plate => '1234CCC')}
  let(:user_aux3) {User.create(:email => 'd@d.d',
                       :password => '11111111',
                       :plate => '4444DDD')}


  let(:create_test_issues_for_opener) {Issue.create(:opener_id => u.id,
                                                  :description => 'park issue',
                                                  :receiver_id => user_aux1.id)
                                     Issue.create(:opener_id => u.id,
                                                  :description => 'park issue new',
                                                  :receiver_id => user_aux2.id)}

  let(:create_test_issues_for_receiver) {Issue.create(:opener_id => user_aux1.id,
                                                        :description => 'park issue',
                                                        :receiver_id => u.id)
                                          Issue.create( :opener_id => user_aux2.id,
                                                        :description => 'park issue new',
                                                        :receiver_id => u.id)
                                          Issue.create( :opener_id => user_aux3.id,
                                                        :description => 'park issue newer',
                                                        :receiver_id => u.id)}

  let(:sign_in_user_u) {within("section.login") do
                            fill_in('user_plate', :with => u.plate)
                            fill_in('user_password', :with => u.password)
                            click_button('Log in')
                           end}

  let(:sign_in_user_user_aux1) {within("section.login") do
                            fill_in('user_plate', :with => user_aux1.plate)
                            fill_in('user_password', :with => user_aux1.password)
                            click_button('Log in')
                           end}


  it "shows the issues list where user is opener" do
    create_test_issues_for_opener
    visit "/users/#{user_aux1.id}/issues"
    sign_in_user_user_aux1
    visit "/users/#{u.id}/issues"

    expect(all('article').count).to be(2)
  end

  it "show info message if doesnt get any issues where the user is the opener" do
    visit "/users/#{user_aux1.id}/issues"
    sign_in_user_user_aux1
    visit "/users/#{u.id}/issues"
    expect(all('article').count).to be(0)
    expect(page.has_css?('p.empty_opened_issues_message')).to be(true)
  end

  it "has a link for each opened issue that redirects to that issue" do
    create_test_issues_for_opener
    visit "/users/#{user_aux1.id}/issues"
    sign_in_user_user_aux1
    visit "/users/#{u.id}/issues"
    within("p.link#{u.opened_issues.first.id}") do
      click_link('Take me to the issue')
    end  
    expect(page.should have_css('form.new_comment')).to be(true)
  end

  it "doesnt show any issue redirection link if the user has not any issues" do 
    visit "/users/#{user_aux1.id}/issues"
    sign_in_user_user_aux1
    visit "/users/#{u.id}/issues"

    expect(all('Take me to the issue').count).to be(0) 
  end

end