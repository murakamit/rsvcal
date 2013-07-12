# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
$ ->
  year  = parseInt($('span#calendar-y').html())
  month = parseInt($('span#calendar-m').html())
  alert year
  alert month
