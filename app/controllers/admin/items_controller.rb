class Admin::ItemsController < Admin::Base
  def new
    @page_title = "Create new item"
    @errors = flash[:errors]
    @group = Item.new
  end

  def create
    @item = Item.create params.require(:item).permit(:group_id, :name, :memo)
    if @item.save
      redirect_to items_path, notice: "created."
    else
      e = @item.errors
      flash[:errors] = e
      n = e.size
      redirect_to new_admin_item_path, alert: "#{n} error#{'s' if n > 1}"
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
