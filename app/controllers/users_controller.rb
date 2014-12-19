class UsersController < ApplicationController

  def search
    user = User.find_by(plate: params[:plate_target])
    if user 
      redirect_to user_issues_path(user.id)
    else
     
      flash[:error] = "This plate doesn´t exist"
      redirect_to user_issues_path(current_user.id)      
    end
  end

end
