class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  # require login and session to be set, else redirect to login page
  def login_required
    unless session[:user_id] && User.find(session[:user_id])
      flash[:notice] = 'Please login first'
      session[:original_request] = request.fullpath
      redirect_to root_url
    end
  end

end
