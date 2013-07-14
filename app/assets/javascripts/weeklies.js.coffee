# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
on_change_date_begin = () ->
  $('#wday').html "(by start date)"
  ymd = $(this).val()
  return unless ymd? || ymd.length == 0
  a = ymd.match /(\d{4})-(\d{1,2})-(\d{1,2})/
  return unless a?
  d = new Date a[1], a[2] - 1, a[3]
  a = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  $('#wday').html "every #{a[d.getDay()]}"

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
set_callback_date_begin = () ->
  obj = $('#weekly_date_begin')
  obj.change(on_change_date_begin) if obj?

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
set_radio_on_at_date_end = () ->
  $('input[name="date_end_using"]:radio').val([1])

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
set_callback_date_end = () ->
  obj = $('#weekly_date_end')
  obj.change(set_radio_on_at_date_end) if obj?

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
$ ->
  set_callback_date_begin()
  set_callback_date_end()
