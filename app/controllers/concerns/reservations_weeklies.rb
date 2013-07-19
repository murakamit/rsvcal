# -*- coding: utf-8 -*-

module ReservationsWeeklies
  # extend ActiveSupport::Concern

  # included do
  # end

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

  def get_reservations(range, item_id = nil)
    if item_id.blank?
      Reservation.where("date >= ? AND date <= ?", range.first, range.last).to_a
    else
      Reservation.where("date >= ? AND date <= ?", range.first, range.last).where(item_id: item_id).to_a
    end
  end

  def get_weeklies(range, item_id = nil)
    ary = []
    weeklies = []

    if item_id.blank?
      weeklies = Weekly.where("date_begin <= ?", range.last)
    else
      weeklies = Weekly.where("date_begin <= ?", range.last).where(item_id: item_id)
    end

    weeklies.each { |x|
      d = range.first
      if x.date_begin < d
        # d += (d.wday - x.wday).abs.days
        d += 1.day while d.wday != x.wday
      else
        d = x.date_begin
      end
      dmax = x.forever? ? range.last : x.date_end
      while d <= dmax
        ary << {
          id: x.id,
          item_id: x.item_id,
          date: d,
          begin_h: x.begin_h,
          begin_m: x.begin_m,
          end_h: x.end_h,
          end_m: x.end_m,
          user: x.user,
          icon: x.icon,
          memo: x.memo,
          updated_at: x.updated_at,
          revoked: Weeklyrevoke.where(weekly_id: x.id, date: d).present?,
        }
        d += 1.week
      end
    }

    ary
  end

  module_function :sort_by_datetime, :get_reservations, :get_weeklies
end
