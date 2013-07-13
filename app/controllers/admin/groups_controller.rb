class Admin::GroupsController < Admin::Base
  def new
    @page_title = "Create new group"
    @group = Group.new
  end

  def create
    @group = Group.create myparams
    if @group.save
      redirect_to groups_path, notice: "created."
    else
      @page_title = "Create new group"
      @errors = @group.errors
      n = @errors.size
      @errormes = "#{n} error#{'s' if n > 1}"
      render :new
    end
  end

  def edit
    @group = Group.find params[:id]
    @page_title = "#{@group.name}"
  rescue
    redirect_to groups_path
  end

  def update
    @group = Group.find params[:id]
    if @group.update myparams
      redirect_to @group, notice: "updated."
    else
      @page_title = "#{@group.name}"
      @errors = @group.errors
      n = @errors.size
      @errormes = "#{n} error#{'s' if n > 1}"
      render :edit
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

  private
  def myparams
    params.require(:group).permit(:name, :memo)
  end
end
