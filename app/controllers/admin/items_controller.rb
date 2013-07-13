class Admin::ItemsController < Admin::Base
  def new
    @page_title = "Create new item"
    @item = Item.new
  end

  def create
    @item = Item.create params.require(:item).permit(:group_id, :name, :memo)
    if @item.save
      redirect_to items_path, notice: "created."
    else
      @page_title = "Create new item"
      @errors = @item.errors
      n = @errors.size
      @errormes = "#{n} error#{'s' if n > 1}"
      render :new
    end
  end

  def edit
    @item = Item.find params[:id]
    @page_title = "#{@item.name}"
    @errors = flash[:errors]
  rescue
    redirect_to items_path
  end

  def update
    item = Item.find params[:id]
    if item.update params.require(:item).permit(:group_id, :name, :memo)
      redirect_to item, notice: "updated."
    else
      e = item.errors
      flash[:errors] = e
      n = e.size
      redirect_to [:edit, :admin, item], alert: "#{n} error#{'s' if n > 1}"
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
end
