class ItemsController < ApplicationController
  include ReservationsWeeklies

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
    range = get_range @year, @month
    a1 = get_reservations(range, id)
    a2 = get_weeklies(range, id)
    @reservations = sort_by_datetime(a1 + a2)
  rescue => e
    # redirect_to items_path, alert: "No such item(##{id})"
    # render text: e
    render text: "No such item(##{id})"
  end

  def show
    d = Date.today
    [:year, :month].each { |k| params[k] = d.send k }
    year_month
  end

  def year_month_day
    @date = Date.new params[:year].to_i, params[:month].to_i, params[:day].to_i
    id = params[:id]
    @item = Item.find id
    @page_title = "#{@item.name}, #{@date.ymdw}"
    a1 = Reservation.where(item_id: id, date: @date)
    a2 = get_weeklies((@date .. @date), id)
    @reservations = sort_by_datetime(a1 + a2)
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
  def get_range(year, month)
    d = Date.new year, month
    d0 = d - d.wday.days
    d9 = d.end_of_month
    d9 += (7 - d9.wday).days
    (d0 .. d9)
  end
  # end
end
