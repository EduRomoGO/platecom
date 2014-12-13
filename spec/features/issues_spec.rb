require_relative '../rails_helper'

describe "User issues page", :type => :feature do

	let(:u) {User.create(:email => 'a@a.a',
    					:password => '12345678',
    					:plate => '1234AAA')}

 	let(:create_test_issues_for_opener) {Issue.create(:opener_id => u.id,
																							 		:description => 'park issue',
																							 		:receiver_id => 2)
																	   Issue.create(:opener_id => u.id,
																							 		:description => 'park issue new',
																							 		:receiver_id => 3)}

 	let(:create_test_issues_for_receiver) {Issue.create(:opener_id => 1,
																										 		:description => 'park issue',
																										 		:receiver_id => u.id)
																			    Issue.create(	:opener_id => 2,
																										 		:description => 'park issue new',
																										 		:receiver_id => u.id)
																			    Issue.create(	:opener_id => 1,
																										 		:description => 'park issue newer',
																										 		:receiver_id => u.id)}

  xit "shows itself when visited" do
    visit '/users/1/issues'
  end

=begin
  xit "capybara test" do
    visit '/users/1/issues'
    page.should have_xpath('//p')
    expect(all('p').count).to be(1)
  end
=end


  it "shows the issues list where user is owner" do

  	create_test_issues_for_opener

    visit "/users/#{u.id}/issues"
    expect(all('article').count).to be(2)
  end

  it "shows the issues list where user is the receiver of the issue" do

		create_test_issues_for_receiver

    visit "/users/#{u.id}/issues"
    expect(all('article').count).to be(3)
  end

  it "show info message if doesnt get any issues where the user is the owner" do

    visit "/users/#{u.id}/issues"
    expect(all('article').count).to be(0)
    expect(page.has_css?('p.empty_opened_issues_message')).to be(true)
    expect(find('p.empty_opened_issues_message').text).to eq('No has abierto ningún issue')
  end

  it "show info message if doesnt get any issues where the user is receiver" do

    visit "/users/#{u.id}/issues"
    expect(all('article').count).to be(0)
    expect(page.has_css?('p.empty_received_issues_message')).to be(true)
  end


  describe "has a form to create a new issue", :type => :feature do

	  it "that has a form tag" do

	    visit "/users/#{u.id}/issues"
	    expect(all('form').count).to be(1)
	  end

	  it "that has an input for the user plate" do

	    visit "/users/#{u.id}/issues"
	    expect(all('input#issue_receiver_id').count).to be(1)
	  end

	  it "where the input for the plate field is empty" do

	    visit "/users/#{u.id}/issues"
	    expect(find('input#issue_receiver_id').text).to eq("")
	  end

	  it "that has one and only one empty description input for the body of the the issue" do

	    visit "/users/#{u.id}/issues"
	    expect(all('input#issue_description').count).to be(1)
	    expect(find('input#issue_description').text).to eq("")
	  end

	  it "that has one button to submit the form" do

	    visit "/users/#{u.id}/issues"
	    expect(all('input[name="commit"]').count).to be(1)
	    expect(find('input[name="commit"]').value).to eq("Save")
	  end

	  it "that has an input hidden which holds the user id value" do

	    visit "/users/#{u.id}/issues"
	    expect(all('input#issue_opener_id').count).to be(1)
	    expect(find('input#issue_opener_id').value).to eq("#{u.id}")
	  end

	end

end