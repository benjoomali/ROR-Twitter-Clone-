class SessionsController < ApplicationController
  def new
  end
  
  def create 
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log the user in and redirect to the user's show page.
      if user.activated?
        log_in user 
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else 
        message = "Account Not Activated"
        message += "Check your Email for the Activation Link"
        flash[:warning] = message
        redirect_to root_url
      end 
    else 
      flash.now[:danger] = 'Invalid email/password combination. Yeah, I would be mad about it too.'
      render 'new'
    end 
  end 
  
  def destroy
    log_out if logged_in? #can only log out if logged in
    redirect_to root_url 
  end 
end
