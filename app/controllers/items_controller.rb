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
    @year = params[:year]
    @month = params[:month]
  rescue
    redirect_to items_index_path, alert: "No such item(##{id})"
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
    ymd = @date.strftime "%Y-%m-%d(%a)"
    @page_title = "#{@item.name}, #{ymd}"
  rescue
    redirect_to items_path
  end

  def today
    d = Date.today
    [:year, :month, :day].each { |k| params[k] = d.send k }
    year_month_day
    render action: :year_month_day
  end
end
