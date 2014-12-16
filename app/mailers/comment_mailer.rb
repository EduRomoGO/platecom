class CommentMailer < ActionMailer::Base
  default from: "from@example.com"

  def new_comment comment
    @comment = comment

    mail = get_mail comment
    
    mail(to: mail, 
      subject: "#{comment.author} ha añadido un comentario al issue comment.issue.id")
  end

  def get_mail comment
    comment_issue = comment.issue
    receiver_id = comment_issue.receiver_id
    opener_id = comment_issue.opener_id

    if commenter_is_the_issue_opener?(comment, opener_id)
      mail = calculate_mail receiver_id
    else
      mail = calculate_mail opener_id
    end
  end

  def commenter_is_the_issue_opener?(comment, opener_id)
    comment.author.id == opener_id
  end

  def calculate_mail id
    mail = User.find_by(id: id).email
  end

end
