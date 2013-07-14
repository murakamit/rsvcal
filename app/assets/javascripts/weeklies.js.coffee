# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
set_week_of_day = () ->
  $('#wday').html "(by start date)"
  ymd = $('#weekly_date_begin').val()
  return unless ymd? || ymd.length == 0
  a = ymd.match /(\d{4})-(\d{1,2})-(\d{1,2})/
  return unless a?
  d = new Date a[1], a[2] - 1, a[3]
  a = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  $('#wday').html "every #{a[d.getDay()]}"

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
set_callback_date_begin = () ->
  obj = $('#weekly_date_begin')
  obj.change(set_week_of_day) if obj?

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
set_radio_on_at_date_end = () ->
  $('input[name="date_end_radio"]:radio').val([1])

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
set_callback_date_end = () ->
  obj = $('#weekly_date_end')
  obj.change(set_radio_on_at_date_end) if obj?

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
$ ->
  set_week_of_day()
  set_callback_date_begin()
  set_callback_date_end()
