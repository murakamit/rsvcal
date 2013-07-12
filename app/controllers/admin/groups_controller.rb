class Admin::GroupsController < Admin::Base
  def new
    @page_title = "Create new group"
    # @errors = flash[:errors]
    @group = Group.new
  end

  def create
    @group = Group.create params.require(:group).permit(:name, :memo)
    if @group.save
      redirect_to groups_path, notice: "created."
    else
      # e = @group.errors
      # flash[:errors] = e
      # n = e.size
      # redirect_to new_admin_group_path, alert: "#{n} error#{'s' if n > 1}"
      @page_title = "Create new group"
      @errors = @group.errors
      n = @errors.size
      flash[:alert] = "#{n} error#{'s' if n > 1}"
      render :new
    end
  end

  def edit
    @group = Group.find params[:id]
    @page_title = "#{@group.name}"
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
    g = Group.find params[:id]    
    g.remove
    redirect_to groups_path, notice: "deleted."
  rescue
    redirect_to groups_path
  end
end
