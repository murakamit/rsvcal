class SessionsController < ApplicationController
  def index
    redirect_to new_session_path unless @login_user
    @page_title = "logout?"
  end

  def new
    redirect_to admin_root_path if @login_user.try :admin?
    @name = flash[:name]
  end

  def create
    name = params[:name]
    u = User.where(name: name).first
    if u && u.authenticate(params[:password])
      session[:login_id] = u.id
      redirect_to(u.admin? ? admin_root_path : root_path)
    else
      flash[:name] = name
      redirect_to new_session_path, alert: "error"
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
