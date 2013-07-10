class Admin::Base < ApplicationController
  before_action :admin_login_required

  private
  def admin_login_required
    unless @login_user.try :admin?
      redirect_to new_session_path
    end
  end
end
