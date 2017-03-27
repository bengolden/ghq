# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  gameStub = $(location).attr('pathname').replace("/games/","")

  $(".game-piece a").click (e)->
    e.preventDefault()
    clearSelectedPieces()
    clearHighlights()
    $(this).addClass("selected-piece")
    backRow = if $(this).data("color") == "white" then '7' else '0'
    if $(this).data("status") == "reserve"
      highlightBackRow(backRow)
    else if $(this).data('unit-type') == "paratrooper" && $(this).closest(".board-square").data("row").toString() == backRow
      highlightEmptySquares()
    else
      highlightAdjacentSquares($(this))
      if $(this).data("unit-type") == "artillery"
        $(this).closest(".board-square").children(".arrow").removeClass("hide")

  highlightBackRow = (backRow) ->
    squares = $(".board-square[data-row='" + backRow + "'][data-empty='true']")
    squares.addClass("highlighted-square")

  highlightEmptySquares = ->
    squares = $(".board-square").filter -> $(this).data("empty") == true
    squares.addClass("highlighted-square")

  highlightAdjacentSquares = (piece) ->
    square = piece.closest(".board-square")
    row = square.data("row")
    column = square.data("column")
    squares = $(".board-square").filter -> $(this).data("row") >= row - 1 && $(this).data("row") <= row + 1 && $(this).data("column") >= column - 1 && $(this).data("column") <= column + 1 && $(this).data("empty") == true
    squares.addClass("highlighted-square")

  $("#game-board").on "click", ".highlighted-square", (e)->
    e.preventDefault()
    destination = $(this)
    square = $(this)
    # do something different for fast pieces
    # adjust the cells to reflect the piece having moved
    selectedPiece = $(".selected-piece").closest(".game-piece")
    if selectedPiece.data("fast") == true
      console.log("I'm fast")
    else
      $.post "/orders",
        type: "Move",
        pieceId: selectedPiece.data("id"),
        newRow: destination.data("row"),
        newColumn: destination.data("column"),
        gameStub: gameStub
        (response)->
          $("#orders-list").append(response)
          square.append(selectedPiece.clone())
          selectedPiece.remove()
          clearSelectedPieces()
          clearHighlights()

  $(".board-square .arrow").click (e)->
    e.preventDefault()
    piece = $(this).closest('.board-square').children(".game-piece")
    direction = $(this).data("direction")

    $.post "/orders",
      type: "Rotate",
      pieceId: piece.data("id"),
      newDirection: direction,
      gameStub: gameStub
      (response)->
        $("#orders-list").append(response)
        setPieceDirection(piece, direction)
        $("#undo-order").removeClass('hide')
        clearSelectedPieces()
        clearHighlights()


  clearSelectedPieces = ->
    $(".selected-piece").removeClass("selected-piece")
    $(".arrow").addClass("hide")

  clearHighlights = ->
    $(".highlighted-square").removeClass("highlighted-square")

  setPieceDirection = (piece, direction) ->
    piece.removeClass("direction-"+piece.data("direction"))
    piece.addClass("direction-"+direction)
    piece.data("direction", direction)
