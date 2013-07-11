class Admin::GroupsController < Admin::Base
  def new
    @page_title = "Create new group"
    @erros = flash[:errors]
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
  end

  def update
  end

  def destroy
  end
end
