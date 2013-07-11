class GroupsController < ApplicationController
  def index
    @page_title = "Groups"
  end

  def show
    id = params[:id]
    @group = Group.find id
    @page_title = @group.name
  rescue
    redirect_to groups_index_path, alert: "No such group(##{id})"
  end
end
