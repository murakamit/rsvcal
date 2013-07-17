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
    range = get_range @year, @month
    @reservations = get_reservations(id, range)
    # @weeklies = get_weeklies(id, range)
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
  def get_range(year, month)
    d = Date.new year, month
    d0 = d - d.wday.days
    d9 = d.end_of_month
    d9 += (7 - d9.wday).days
    (d0 .. d9)
  end

  def get_reservations(item_id, range)
    r = Reservation.order :date, :begin_h, :begin_m, :end_h, :end_m
    r = r.where item_id: item_id
    r.where("date >= ? AND date <= ?", range.first, range.last)
  end

  # def get_weeklies(item_id, range)
  #   r = Weekly.order :date_begin, :begin_h, :begin_m, :end_h, :end_m
  #   r = r.where item_id: item_id
  #   r = r.where("date_begin >= ? AND date_begin <= ?", *range)
  #   weeklies = r.to_a.map { |w| [w.date_begin, w] }
  #   result = []
  #   range.each { |d|
  #
  #   }
  #   result
  # end
end
