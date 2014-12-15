class IssueMailer < ActionMailer::Base
  default from: "nuevo_parking_issue@platecom.com"

  def issue_created(issue, plate_of_issue_opener)
    @plate_of_issue_opener = plate_of_issue_opener
    @issue = issue
    email_of_issue_receiver = User.find_by(id: issue.receiver_id).email
    mail(to: email_of_issue_receiver, 
         subject: "#{@plate_of_issue_opener} te ha mencionado en un parking issue")
  end

end
