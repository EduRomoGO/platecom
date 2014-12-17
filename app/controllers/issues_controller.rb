class IssuesController < ApplicationController

	def index

		user_url = User.find params[:user_id]

		if( (user_signed_in?) and (current_user == user_url) )
			@user = current_user
			@issue = Issue.new
			@received_issues = @user.received_issues.order(created_at: :desc)
			@opened_issues = @user.opened_issues.order(created_at: :desc)
		elsif( (user_signed_in?) and (current_user != user_url) )
      #binding.pry
      @user = user_url
      @issue = Issue.new
      @opened_issues = @user.opened_issues.order(created_at: :desc)
      render 'public_issues'
    else
			@user = User.new
		end

	end

	def create
    opener = User.find_by(plate: params[:issue][:receiver_id])
    @plate = params[:issue][:receiver_id]
    if opener
      @issue = Issue.new(issue_params)
      @issue.receiver_id = opener.id
      @plate_of_issue_opener = User.find_by(id: @issue.opener_id).plate
  		if @issue.save
        IssueMailer.issue_created(@issue, @plate_of_issue_opener).deliver
  			respond_to do |format|
  				format.js do
  					render(
  						partial: 'create_issue',
  						locals: { resource: @issue })
  				end
  			end
  		end
    else
          #render 'user_does_not_exist'
      respond_to do |format|
        format.js do
          render(
            partial: 'user_does_not_exist_msg',
            locals: { resource: @plate })
        end
      end
    end
	end

	def show
    if(current_user_matches_url_user? and url_issue_is_related_to_current_user?)
  		@issue = Issue.find (params[:id])
  		@comments = @issue.comments.order(created_at: :desc)
  		@comment = Comment.new
    else
      render 'this_issue_is_not_related_to_you.html'
    end
	end


  private

  def issue_params
    params.require(:issue).permit(:opener_id, :description)
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
