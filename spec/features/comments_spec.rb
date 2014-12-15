require_relative '../rails_helper'

describe "Issues comments page", :type => :feature do

	let(:u) {User.create(:email => 'a@a.a',
    					:password => '12345678',
    					:plate => '1234AAA')}

	let(:i) {Issue.create(:opener_id => u.id,
										 		:description => 'park issue',
										 		:receiver_id => u.id)}

	let(:create_two_comments_for_i) {Comment.create(:issue_id => i.id,
																			 		 :body => 'great job parking!')
														Comment.create(:issue_id => i.id,
																			 		 :body => 'not so good parking...')}


  let(:sign_in_user_u) {within("section.login") do
                            fill_in('user_plate', :with => u.plate)
                            fill_in('user_password', :with => u.password)
                            click_button('Log in')
                           end}

  it "shows itself when visited" do
    visit "/users/#{u.id}/issues"
    sign_in_user_u
    visit "/users/#{u.id}/issues/#{i.id}"
  end

  it "shows an issue" do
    visit "/users/#{u.id}/issues"
    sign_in_user_u
    visit "/users/#{u.id}/issues/#{i.id}"
    expect(all('article.issue').count).to be(1)    
  end

  it "shows the comments for the issue" do
    visit "/users/#{u.id}/issues"
    sign_in_user_u
  	create_two_comments_for_i
    visit "/users/#{u.id}/issues/#{i.id}"
    expect(all('article.comment').count).to be(2)  
  end

  it "shows a message when the issue has no comments" do
    visit "/users/#{u.id}/issues"
    sign_in_user_u
    visit "/users/#{u.id}/issues/#{i.id}"
    expect(find('.no_comments').text).to eq('El issue no tiene comentarios')  
  end

  it "shows a form to create comments for the issue" do
    visit "/users/#{u.id}/issues"
    sign_in_user_u
    visit "/users/#{u.id}/issues/#{i.id}"
    num_articles = all('article.comment').count
		within("section.new_comment") do
			fill_in('comment_body', :with => "comment body")
			click_button('new_comment')
	   end
    expect(all('article.comment').count).to be(num_articles+1) 
  end

  xit "has a link that redirects to user issues" do
    visit "/users/#{u.id}/issues"
    sign_in_user_u
    visit "/users/#{u.id}/issues/#{i.id}"
    click_link('Ir a Issues')
    expect(page.should have_css('form.new_session')).to be(true)
  end
 
end