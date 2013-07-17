# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
# http://www.bht.co.jp/javascript/
shunbun = (y) ->
  return if y < 1980 or y > 2099
  x = 20.8431 + 0.242194 * (y - 1980) - Math.floor((y - 1980) / 4)
  return Math.floor(x)

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
# http://www.bht.co.jp/javascript/
shu_bun = (y) ->
  return if y < 1980 or y > 2099
  x = 23.2488 + 0.242194 * (y - 1980) - Math.floor((y - 1980) / 4)
  return Math.floor(x)

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
get_holidays = (year) ->
  year = parseInt year
  year ?= (new Date()).getFullYear()

  holidays = [
    [],   # dummy
    [1],  # 1
    [11], # 2
    [],   # 3
    [29], # 4
    [3, 4, 5], # 5
    [], # 6
    [], # 7
    [], # 8
    [], # 9
    [], # 10
    [3, 23], # 11
    [23], # 12
  ]

  # happy_mondays
  happy_mondays = [
    [ 1, 2], # seijin no hi
    [ 7, 3], # umi no hi
    [ 9, 3], # keirou no hi
    [10, 2], # taiiku no hi
  ]

  for a in happy_mondays
    d = new Date(year, a[0] - 1, 1)
    n = if d.getDay() == 1 then 1 else 0
    while n < a[1]
      d.setDate(d.getDate() + 1)
      n += 1 if d.getDay() == 1
    #end while
    holidays[a[0]].push d.getDate()
  # end for

  # shunbun, shu_bun
  holidays[3].push shunbun(year)
  holidays[9].push shu_bun(year)

  # furikae?
  for i in [1..12]
    a = holidays[i]
    continue if a.length == 0
    for x, j in a
      d = new Date(year, i, x)
      continue if d.getDay() != 0
      x += 1
      while $.inArray(x, a) >= 0
        x += 1;
      # end while
      a[j] = x;
    #end for
  #end for

  return holidays

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
isolate_ymd = (ymd) ->
  a = ymd.match /^(\d{4})-(\d{1,2})-(\d{1,2})$/
  return if a? then [parseInt(a[1]), parseInt(a[2]), parseInt(a[3])] else null

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
generate_ymd = (y, m, d) ->
  return "#{y}-#{m}-#{d}"

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
get_calendar_td = (y, m, d) ->
  ymd = if y and m and d then generate_ymd(y, m, d) else y
  return $("table#calendar td[ymd=#{ymd}]")

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
build_header = (sunday_end = false) ->
  sunday = '<th class="sunday">Sun</th>'
  s = '<th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th>'
  s += '<th class="saturday">Sat</th>'
  if sunday_end
    s += sunday
  else
    s = sunday + s
  # end if
  return $("<tr>#{s}</tr>")

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
generate_weeks = (year, month, sunday_end = false) ->
  weeks = []
  days = []
  month -= 1
  d = new Date(year, month, 1)
  n = d.getDay() # sun:0, mon:1, ... , sat:6

  if sunday_end
     n = if n > 0 then (n - 1) else 6
  # end if

  while n > 0
    d.setDate(d.getDate() - 1)
    days.unshift([d.getFullYear(), d.getMonth() + 1, d.getDate()])
    --n
  # end while

  d = new Date(year, month, 1)

  while days.length < 7
    days.push([d.getFullYear(), d.getMonth() + 1, d.getDate()])
    d.setDate(d.getDate() + 1)
  # end while

  weeks.push(days)

  while d.getMonth() == month
    days = []
    while days.length < 7
      days.push([d.getFullYear(), d.getMonth() + 1, d.getDate()])
      d.setDate(d.getDate() + 1)
    # end while
    weeks.push days
  # end while

  return weeks

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
build_week = (days) ->
  s = ''
  a = location.href.match /^(.+\/items\/\d+).*$/
  url = a[1]
  for day in days
    y = day[0]
    m = day[1]
    d = day[2]
    s += '<td ymd="' + generate_ymd(y,m,d) + '"'
    s += ' year="' + y + '"'
    s += ' month="' + m + '"'
    s += ' day="' + d + '"'
    href = "#{url}/#{y}-#{m}-#{d}"
    s += '><a href="' + href + '">' + d + '</a></td>'
  # end for

  return $("<tr>#{s}</tr>")

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
colorize_week = (week, sunday_end = false) ->
  days = week.children()
  first = days.first()
  last = days.last()
  if sunday_end
    last.prev().addClass "saturday"
    last.addClass "sunday"
  else
    first.addClass "sunday"
    last.addClass "saturday"
  # end if

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
colorize_holidays = (year, month) ->
  h = get_holidays(year)
  tupple = [year, month, h[month]]
  all = [ tupple ]

  switch month
    when 1
      all.push [year, 2, h[2]]
      h = get_holidays(year-1)
      all.push [year-1, 12, h[12]]
    when 12
      all.push [year, 11, h[11]]
      h = get_holidays(year+1)
      all.push [year+1, 1, h[1]]
    else
      all.push [year, month-1, h[month-1]]
      all.push [year, month+1, h[month+1]]
  # end switch

  for t in all
    y = t[0]
    m = t[1]
    for hol in t[2]
      td = get_calendar_td(y, m, hol)
      td.addClass("holiday") if td.length > 0
    # end for
  # end for

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
build_calendar_main = (table, year, month, sunday_end = false) ->
  table.empty()
  obj = $('<thead></thead>')
  obj.append build_header(sunday_end), sunday_end
  table.append obj
  table.append $('<tbody></tbody>')

  for w in generate_weeks(year, month, sunday_end)
    obj = build_week w
    colorize_week obj, sunday_end
    table.append obj
  # end for

  colorize_holidays year, month

  a = []
  switch month
    when 1
      a = [12, 2]
    when 12
      a = [11, 1]
    else
      a = [month - 1, month + 1]
  # end switch

  for m in a
    $("table#calendar td[month=#{m}]").addClass "out-of-range"
  # end for

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
build_calendar = () ->
  year = parseInt $('span#calendar-y').html()
  return false unless year?
  month = parseInt $('span#calendar-m').html()
  return false unless month?
  calendar = $("table#calendar")
  if calendar.length > 0
    build_calendar_main calendar, year, month
    return true
  else
    return false
  # end if

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
reservation_tr2hash = (tr) ->
  columns = $(tr).children()
  return {} if columns?.length == 0
  h = {}
  for k in ['rid', 'wid', 'icon', 'date', 'begin', 'end', 'user']
    h[k] = columns.filter('td[class=' + k + ']').html();
    h['new'] = $(tr).hasClass('newrid')
  # end for

  ymd = h['date']
  if ymd?
    a = isolate_ymd ymd
    h['year'] = a[0]
    h['month'] = a[1]
    h['day'] = a[2]
  # end if

  k = 'canceled'
  h[k] = true if $(tr).hasClass(k)

  return h

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
generate_hover_tips = (h) ->
  s = "#{h['icon']}\n"
  s += "#{h['date']}\n"
  s += "#{h['begin']} - #{h['end']}\n"
  s += h['user']
  return s

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
put_icons_on_calendar = () ->
  return unless $("table#calendar")?
  ary_tr = $('tr.reservation')
  return if tr?.length == 0
  for tr in ary_tr
    h = reservation_tr2hash(tr)
    continue unless h?
    continue if h['canceled']
    td = get_calendar_td h['year'], h['month'], h['day']
    td.append '<br>' if td.children('br').length == 0

    url = ''
    rid = h['rid']
    wid = ''
    if rid?.length > 0
      url = "/reservations/#{rid}"
    else
      wid = h['wid']
      url = "/weeklies/#{wid}" if wid?.length > 0
    # end if

    s = '<a href="' + url + '"'
    s += ' class="icon'
    s += ' newrid' if h['new']
    s += '"'
    s += ' rid="' + h["rid"] + '"' if rid.length > 0
    s += ' wid="' + h["wid"] + '"' if wid.length > 0

    s += '>' + h["icon"] + '</a>'

    obj = $(s)
    obj.attr 'title', generate_hover_tips(h)
    td.append obj
  # end for

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
$ ->
  put_icons_on_calendar() if build_calendar()
