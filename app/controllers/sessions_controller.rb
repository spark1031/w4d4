#no session_params private method necessary - we only access our params[:user]
class SessionsController < ApplicationController

  def new
    render :new
  end

  #finds our user by her credentials (find_by_credentials)
  #do the same thing as UsersController#create
  def create
    @user = User.find_by_credentials(params[:user][:email], params[:user][:password])
    if @user
      log_in_user!(user)
      redirect_to user_url(user)
    else
      flash.now[:errors] = user.errors.full_messages
      render :new
    end
  end

  #logout! user
  #redirect_to the login page
  def destroy
    logout!
    redirect_to new_session_url
  end

end
