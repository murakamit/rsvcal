# -*- coding: utf-8 -*-

module ItemsHelper
  def nav_prev(year, month)
    y = year
    m = month - 1
    if m < 1
      y -= 1
      m = 12
    end
    link_to "&laquo;prev".html_safe, action: :year_month, year: y, month: m
  end

  def nav_next(year, month)
    y = year
    m = month + 1
    if m > 12
      y += 1
      m = 1
    end
    link_to "next&raquo;".html_safe, action: :year_month, year: y, month: m
  end
end
