class Admin::GroupsController < Admin::Base
  include ErrorDisplayable

  def new
    @page_title = "Create new group"
    @group = Group.new
  end

  def create
    @group = Group.create myparams
    if @group.save
      redirect_to groups_path, notice: "created."
    else
      display_errors @group.errors, :new, "Create new group"
    end
  end

  def edit
    @group = Group.find params[:id]
    @page_title = @group.name
  rescue
    redirect_to groups_path
  end

  def update
    @group = Group.find params[:id]
    name = @group.name
    if @group.update myparams
      redirect_to @group, notice: "updated."
    else
      display_errors @group.errors, :edit, name
    end
  rescue
    redirect_to groups_path
  end

  def destroy
    g = Group.find params[:id]    
    if g.remove
      redirect_to groups_path, notice: "deleted."
    else
      redirect_to g, alert: "Error.#{" (Group with some items is protected)" unless g.items.empty?}"
    end
  rescue
    redirect_to groups_path, alert: "error"
  end

  private
  def myparams
    params.require(:group).permit(:name, :memo)
  end
end
