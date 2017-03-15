# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $(".game-piece a").click (e)->
    e.preventDefault()
    clearSelectedPieces()
    clearHighlights()
    $(this).addClass("selected-piece")
    if $(this).data("status") == "reserve"
      deployRow = if $(this).data("color") == "white" then '7' else '0'
      squares = $(".board-square[data-row='" + deployRow + "'][data-empty='true']")
    else
      square = $(this).closest(".board-square")
      row = square.data("row")
      column = square.data("column")
      squares = $(".board-square").filter -> $(this).data("row") >= row - 1 && $(this).data("row") <= row + 1 && $(this).data("column") >= column - 1 && $(this).data("column") <= column + 1 && $(this).data("empty") == true

      # if artillery show arrows
    squares.addClass("highlighted-square")

  clearSelectedPieces = ->
    $(".selected-piece").removeClass("selected-piece")

  clearHighlights  = ->
    $(".highlighted-square").removeClass("highlighted-square")