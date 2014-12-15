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

	def show
		@issue = Issue.find (params[:id])
		@comments = @issue.comments
		@comment = Comment.new
	end


  def issue_params
    params.require(:issue).permit(:opener_id, :receiver_id, :description)
  end

end
