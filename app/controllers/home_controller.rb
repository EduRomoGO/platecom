class HomeController < ApplicationController

  def index
    if user_signed_in?
      redirect_to user_issues_path(current_user.id) 
    else  
      @user = User.new
      render 'index'
    end
  end

end
