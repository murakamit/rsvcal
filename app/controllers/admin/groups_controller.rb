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
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
