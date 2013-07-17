class ItemsController < ApplicationController
  def index
    @page_title = "Items"
  end

  def prop
    id = params[:id]
    @item = Item.find id
    @page_title = @item.name
  rescue
    redirect_to items_index_path, alert: "No such item(##{id})"
  end

  def year_month
    id = params[:id]
    @item = Item.find id
    @page_title = @item.name
    @year = params[:year].to_i
    @month = params[:month].to_i
    @reservations = get_reservations(@year, @month, id)
    # @weeklies = Weekly.all
  rescue
    redirect_to items_path, alert: "No such item(##{id})"
  end

  def show
    d = Date.today
    [:year, :month].each { |k| params[k] = d.send k }
    year_month
    render action: :year_month
  end

  def year_month_day
    @date = Date.new params[:year].to_i, params[:month].to_i, params[:day].to_i
    @item = Item.find params[:id]
    @page_title = "#{@item.name}, #{@date.ymdw}"
  rescue
    redirect_to items_path
  end

  def today
    d = Date.today
    [:year, :month, :day].each { |k| params[k] = d.send k }
    year_month_day
    render action: :year_month_day
  end

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  private
  def get_reservations(year, month, item_id)
    r = Reservation.order :date ,:begin_h, :begin_m, :end_h, :end_m
    r = r.where item_id: item_id
    d = Date.new year, month
    d0 = d - d.wday.days
    d9 = d.end_of_month
    d9 += (7 - d9.wday).days
    r.where("date >= ? AND date <= ?", d0, d9)
  end
end
