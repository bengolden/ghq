# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $(".game-piece a").click (e)->
    e.preventDefault()
    if $(this).data("status") == "reserve"
      # highlight back row
    else
      # highlight adjacent cells
      # if artillery show arrows