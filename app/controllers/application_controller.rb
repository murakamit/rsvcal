class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize

  private
  def authorize
    lid = session[:login_id]
    return unless lid
    begin
      @login_user = User.find lid
    rescue
      session.delete :login_id
    end
  end
end
