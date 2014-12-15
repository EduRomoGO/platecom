class IssuesController < ApplicationController

	def index

		user_url = User.find params[:user_id]

		if( (user_signed_in?) and (current_user == user_url) )
			@user = current_user
			@issue = Issue.new
			@received_issues = @user.received_issues
			@opened_issues = @user.opened_issues
		else
			@user = User.new
		end

	end

	def create
		@issue = Issue.new(issue_params)
		
		if @issue.save
			respond_to do |format|
				format.js do
					render(
						partial: 'create_issue',
						locals: { resource: @issue })
				end
			end
		end
	end

  def issue_params
    params.require(:issue).permit(:opener_id, :receiver_id, :description)
  end


	def show
    if(current_user_matches_url_user? and url_issue_is_related_to_current_user?)
  		@issue = Issue.find (params[:id])
  		@comments = @issue.comments
  		@comment = Comment.new
    else
      render 'this_issue_is_not_related_to_you.html'
    end
	end

  def current_user_matches_url_user?
    user_url = User.find params[:user_id]
    current_user_comes_in_url = ((current_user == user_url) and user_signed_in?)
  end

  def url_issue_is_related_to_current_user?
    issue_url = Issue.find params[:id]
    current_user_related_issues = current_user.opened_issues + current_user.received_issues
    current_user_related_issues.include? issue_url
  end


end
