class Admin::ItemsController < Admin::Base
  include ErrorDisplayable

  def new
    @page_title = "Create new item"
    @item = Item.new
  end

  def create
    @item = Item.create myparams
    if @item.save
      redirect_to items_path, notice: "created."
    else
      display_errors @item.errors, :new, "Create new item"
    end
  end

  def edit
    @item = Item.find params[:id]
    @page_title = @item.name
  rescue
    redirect_to items_path
  end

  def update
    @item = Item.find params[:id]
    name = @item.name
    if @item.update myparams
      redirect_to [:prop, @item], notice: "updated."
    else
      display_errors @item.errors, :edit, name
    end
  rescue
    redirect_to items_path
  end

  def destroy
    item = Item.find params[:id]    
    item.remove
    redirect_to items_path, notice: "deleted."
  rescue
    redirect_to items_path
  end

  private
  def myparams
    params.require(:item).permit(:group_id, :name, :memo)
  end
end
