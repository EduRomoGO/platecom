class IssuesController < ApplicationController

  before_action :authenticate_user!

	def index

    if current_user
      if current_user_visiting_his_issues?
        send_current_user_values_to_index
      else
        send_user_from_url_values_to_public_issues
        render 'public_issues'
      end
    else
      redirect_to '/'
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
    if current_user
      if current_user_visiting_his_issues? and url_issue_is_related_to_current_user?
    		@issue = Issue.find (params[:id])
    		@comments = @issue.comments.order(created_at: :desc)
    		@comment = Comment.new
      else
        @user = User.new
        @related_to_user = false
        render 'this_issue_is_not_related_to_you'
      end
    else
      redirect_to '/'
    end
	end


  private

  def current_user_visiting_his_issues?
    user_from_url = User.find params[:user_id]
    current_user_visiting_his_issues = current_user == user_from_url
  end

  def send_current_user_values_to_index
      @issue = Issue.new
      @user = current_user
      @received_issues = @user.received_issues.order(created_at: :desc)
      @opened_issues = @user.opened_issues.order(created_at: :desc)
  end

  def send_user_from_url_values_to_public_issues
      user_from_url = User.find params[:user_id]
      @issue = Issue.new  
      @user = user_from_url
      @opened_issues = @user.opened_issues.order(created_at: :desc)
  end

  def issue_params
    params.require(:issue).permit(:opener_id, :description)
  end

  def url_issue_is_related_to_current_user?
    issue_url = Issue.find params[:id]
    current_user_related_issues = current_user.opened_issues + current_user.received_issues
    current_user_related_issues.include? issue_url
  end


end
