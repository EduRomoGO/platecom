class UsersController < ApplicationController

  def search
    user = User.find_by(plate: params[:plate_target])

    redirect_to user_issues_path(user.id)
  end

end
