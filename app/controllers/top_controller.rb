class TopController < ApplicationController
  include ReservationsWeeklies

  def year_month_day
    @date = Date.new params[:year].to_i, params[:month].to_i, params[:day].to_i
    @page_title = @date.ymdw
    a1 = Reservation.where(date: @date)
    a2 = get_weeklies(@date .. @date)
    @reservations = sort_by_datetime(a1 + a2)
rescue => e
    redirect_to root_path
    # render text: e
  end

  def today
    @today = Date.today
    [:year, :month, :day].each { |k| params[k] = @today.send k }
    year_month_day
    render action: :year_month_day
  end

  def index
    @today = Date.today
    [:year, :month, :day].each { |k| params[k] = @today.send k }
    year_month_day

    @more_days = 2
    range = @today .. (@today + @more_days.days)
    a1 = get_reservations range
    a2 = get_weeklies range
    @mores = sort_by_datetime(a1 + a2)
  end
end
