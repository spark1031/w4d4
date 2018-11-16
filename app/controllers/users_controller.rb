class UsersController < ApplicationController

  def new
    render :new
  end

  #create the new user using user_params
  #if we can save this user, then log her in and redirect to her show page
  #else put her erros into flash.now[:errors] and render :new w the errors displayed
  def create
    user = User.new(user_params)
    if user.save
      login(user)
      redirect_to user_url(user)
    else
      flash.now[:errors] = user.errors.full_messages
      render :new
    end
  end

  #find user by :id
  #save this user as an instance var (@user) so we can access in our views
  def show
    @user = User.find(params[:id])
    render :show
  end

  private
  def user_params
    Params.require(:user).permit(:email, :password)
  end
end
