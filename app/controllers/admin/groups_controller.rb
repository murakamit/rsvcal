class Admin::GroupsController < Admin::Base
  def new
    @page_title = "Create new group"
    @errors = flash[:errors]
    @group = Group.new
  end

  def create
    @group = Group.create params.require(:group).permit(:name, :memo)
    if @group.save
      redirect_to new_admin_group_path, notice: "created #{url_for @group}"
    else
      e = @group.errors
      flash[:errors] = e
      n = e.size
      redirect_to new_admin_group_path, alert: "#{n} error#{'s' if n > 1}"
    end
  end

  def edit
    @group = Group.find params[:id]
    @page_title = "Edit #{@group.name}"
    @errors = flash[:errors]
  rescue
    redirect_to groups_path
  end

  def update
    g = Group.find params[:id]
    if g.update params.require(:group).permit(:name, :memo)
      redirect_to g, notice: "updated."
    else
      e = g.errors
      flash[:errors] = e
      n = e.size
      redirect_to [:edit, :admin, g], alert: "#{n} error#{'s' if n > 1}"
    end
  rescue
    redirect_to groups_path
  end

  def destroy
  end
end
