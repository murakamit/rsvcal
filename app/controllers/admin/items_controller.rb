class Admin::ItemsController < Admin::Base
  include ErrorDisplayable

  def new
    @page_title = "Create new item"
    @item = Item.new
  end

  def create
    @item = Item.create myparams
    if @item.save
      s = save_photo @item
      @item.update photo: s if s
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

    h = myparams
    s = save_photo @item
    h[:photo] = s if s

    if @item.update h
      redirect_to [:prop, @item], notice: "updated."
    else
      display_errors @item.errors, :edit, name
    end
  rescue
    redirect_to items_path
  end

  def destroy
    item = Item.find params[:id]    
    if item.remove
      redirect_to items_path, notice: "deleted."
    else
      redirect_to item, alert: "Error."
    end
  rescue
    redirect_to items_path, alert: "error"
  end

  private
  def myparams
    # params.require(:item).permit(:group_id, :name, :memo)
    result = {}
    h = params[:item]
    if h && ( h.is_a? Hash )
      [:group_id, :name, :memo].each { |k| result[k] = h[k] }
    end
    result
  end

  def save_photo(obj)
    h = params[:item]
    return nil if h.blank?
    x = h[:photo]
    x.present? ? obj.save_photo(x) : nil
  end
end
