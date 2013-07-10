class Admin::GroupsController < Admin::Base
  def index
  end

  def show
  end

  def new
    @page_title = "Create new group"
    @group = Group.new
  end

  def create
    @group = Group.create params.require(:group).permit(:name, :memo)
    if @group.save
      s = "created #{link_to_unless_current @group}"
      redirect_to new_admin_group_path, notice: s
    else
      @page_title = "Create new group"
      n = @group.errors.size
      flash.alert = "#{n} error#{'s' if n > 1}"
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
