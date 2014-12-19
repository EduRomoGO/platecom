require_relative '../rails_helper'

describe "User issues page", :type => :feature do

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
																			    Issue.create(	:opener_id => user_aux2.id,
																										 		:description => 'park issue new',
																										 		:receiver_id => u.id)
																			    Issue.create(	:opener_id => user_aux3.id,
																										 		:description => 'park issue newer',
																										 		:receiver_id => u.id)}

	let(:sign_in_user_u) {within("section.login") do
														fill_in('user_plate', :with => u.plate)
														fill_in('user_password', :with => u.password)
														click_button('Log in')
											     end}


  it "shows itself when visited" do
    visit "/users/#{u.id}/issues"
  end

  it "shows the issues list where user is opener" do
  	create_test_issues_for_opener
    visit "/users/#{u.id}/issues"
  	sign_in_user_u

    expect(all('article').count).to be(2)
  end

  it "shows the issues list where user is the receiver of the issue" do
		create_test_issues_for_receiver

    visit "/users/#{u.id}/issues"
  	sign_in_user_u
    expect(all('article').count).to be(3)
  end

  it "show info message if doesnt get any issues where the user is the opener" do
    visit "/users/#{u.id}/issues"
  	sign_in_user_u
    expect(all('article').count).to be(0)
    expect(page.has_css?('p.empty_opened_issues_message')).to be(true)
    expect(find('p.empty_opened_issues_message').text).to eq('You have not opened any issue')
  end

  it "show info message if doesnt get any issues where the user is receiver" do
    visit "/users/#{u.id}/issues"
  	sign_in_user_u
    expect(all('article').count).to be(0)
    expect(page.has_css?('p.empty_received_issues_message')).to be(true)
  end

  it "has a link for each opened issue that redirects to that issue" do
    create_test_issues_for_opener
    visit "/users/#{u.id}/issues"
    sign_in_user_u
    within("p.link#{u.opened_issues.first.id}") do
      click_link('Take me to the issue')
    end  
    expect(page.should have_css('form.new_comment')).to be(true)
  end

  it "has a link for each received issue that redirects to that issue" do 
    create_test_issues_for_receiver
    visit "/users/#{u.id}/issues"
    sign_in_user_u
    within("p.link#{u.received_issues.first.id}") do
      click_link('Take me to the issue')
    end  
    expect(page.should have_css('form.new_comment')).to be(true)  
  end

  it "doesnt show any issue redirection link if the user has not any issues" do 
    visit "/users/#{u.id}/issues"
    sign_in_user_u

    expect(all('Take me to the issue').count).to be(0) 
  end

  describe "has a form to create a new issue", :type => :feature do
	 
    it "that has a form tag" do
	    visit "/users/#{u.id}/issues"
  		sign_in_user_u
	    expect(all('form.new_issue').count).to be(1)
	  end

	  it "that has an input for the user plate" do

	    visit "/users/#{u.id}/issues"
  		sign_in_user_u	    
	    expect(all('input#issue_receiver_id').count).to be(1)
	  end

	  it "where the input for the plate field is empty" do

	    visit "/users/#{u.id}/issues"
  		sign_in_user_u
	    expect(find('input#issue_receiver_id').text).to eq("")
	  end

	  it "that has one and only one empty description input for the body of the the issue" do

	    visit "/users/#{u.id}/issues"
  		sign_in_user_u
	    expect(all('textarea#issue_description').count).to be(1)
	    expect(find('textarea#issue_description').text).to eq("")
	  end

	  it "that has one button to submit the form" do

	    visit "/users/#{u.id}/issues"
  		sign_in_user_u	    
	    expect(all('input.new_issue_button').count).to be(1)
	    expect(find('input.new_issue_button').value).to eq("Save")
	  end

	  it "that has an input hidden which holds the issue opener id value" do

	    visit "/users/#{u.id}/issues"
  		sign_in_user_u	    
	    expect(all('input#issue_opener_id').count).to be(1)
	    expect(find('input#issue_opener_id').value).to eq("#{u.id}")
	  end
	end

end