require_relative '../rails_helper'
 
describe "Issues mailer" do
  let(:user) {User.create(:email => 'a@a.a',
                          :password => '12345678',
                          :plate => '1234AAA')}
  let(:user2) {User.create(:email => 'z@z.z',
                          :password => '12345678',
                          :plate => '1234ZZZ')}
  let(:issue) {Issue.create(:opener_id => user.id,
                            :description => 'park issue',
                            :receiver_id => user2.id)}
  let(:issue_mailer) {IssueMailer.issue_created(issue, user.plate)}
 
  it "sends an email" do
    expect { issue_mailer }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end