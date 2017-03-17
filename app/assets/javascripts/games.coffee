# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $(".game-piece a").click (e)->
    e.preventDefault()
    clearSelectedPieces()
    clearHighlights()
    $(this).addClass("selected-piece")
    backRow = if $(this).data("color") == "white" then '7' else '0'

    if $(this).data("status") == "reserve"
      squares = $(".board-square[data-row='" + backRow + "'][data-empty='true']")
    else if $(this).data('unit-type') == "paratrooper" && $(this).closest(".board-square").data("row").toString() == backRow
      squares = $(".board-square").filter -> $(this).data("empty") == true
    else
      square = $(this).closest(".board-square")
      row = square.data("row")
      column = square.data("column")
      squares = $(".board-square").filter -> $(this).data("row") >= row - 1 && $(this).data("row") <= row + 1 && $(this).data("column") >= column - 1 && $(this).data("column") <= column + 1 && $(this).data("empty") == true

      if $(this).data("unit-type") == "artillery"
        $(this).closest(".board-square").children(".arrow").removeClass("hide")
    squares.addClass("highlighted-square")


  clearSelectedPieces = ->
    $(".selected-piece").removeClass("selected-piece")
    $(".arrow").addClass("hide")

  clearHighlights  = ->
    $(".highlighted-square").removeClass("highlighted-square")