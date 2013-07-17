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
    a1 = get_reservations(id, range)
    a2 = get_weeklies(id, range)
    @reservations = sort_by_datetime(a1 + a2)
  rescue => e
    # redirect_to items_path, alert: "No such item(##{id})"
    # render text: "No such item(##{id})"
    render text: e
  end

  def show
    d = Date.today
    [:year, :month].each { |k| params[k] = d.send k }
    year_month
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

  def sort_by_datetime(a)
    a.sort { |x,y|
      v = nil
      [:date, :begin_h, :begin_m, :end_h, :end_m].each { |k|
        v = x[k] <=> y[k]
        break if v != 0
      }
      v
    }
  end

  def get_reservations(item_id, range)
    r = Reservation.where(item_id: item_id)
    r = r.where("date >= ? AND date <= ?", range.first, range.last)
    r.to_a
  end

  def get_weeklies(item_id, range)
    r = Weekly.where(item_id: item_id)
    r = r.where("date_begin <= ?", range.last)
    weeklies = []

    r.each { |x|
      d = range.first
      if x.date_begin < d
        d += (d.wday - x.wday).abs.days
      else
        d = x.date_begin
      end
      dmax = x.forever? ? range.last : x.date_end
      while d <= dmax
        weeklies << {
          id: x.id,
          date: d,
          begin_h: x.begin_h,
          begin_m: x.begin_m,
          end_h: x.end_h,
          end_m: x.end_m,
          user: x.user,
          icon: x.icon,
          memo: x.memo,
          revoked: Weeklyrevoke.where(weekly_id: x.id, date: d).present?,
        }
        d += 1.week
      end
    }

    weeklies
  end
end
