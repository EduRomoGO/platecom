class IssuesController < ApplicationController

	def index
		@issue = Issue.new
		@received_issues = Issue.where(receiver_id: params[:user_id])
		begin
			#binding.pry
			@user = User.find params[:user_id]
			if(@user.opened_issues.count > 0)
					@opened_issues = User.first.opened_issues
			else
					@opened_issues = []		
			end
		rescue ActiveRecord::RecordNotFound
			@opened_issues = []
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
