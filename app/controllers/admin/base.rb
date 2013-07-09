class Admin::Base < ApplicationController
  before_action :admin_login_required

  private
  def admin_login_required
    unless @login_user.try(:admin?)
      render status: :forbidden, text: "not admin user"
    end
  end
end
