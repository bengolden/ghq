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
      if $(this).data("direction") != null
        $(this).closest(".board-square").children(".arrow").removeClass("hide")

  $("#confirm-orders").click (e)->
    e.preventDefault()
    $.post "/games/" + gameStub,
      _method: 'PUT'
      (response)->
        $("#orders-list li").remove()
        $("#turn-number").text( parseInt($("#turn-number").text()) + 1 )
        activePlayer = $("#active-player")
        $("#undo-order").addClass('hide')
        $("#confirm-orders").addClass('hide')
        if activePlayer.text() == "white"
          activePlayer.text("black")
        else
          activePlayer.text("white")
        $(".game-piece." + activePlayer.text() + "-piece a").removeClass('disabled')


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
    intermediate = $(".intermediate-square")
    square = $(this)
    # TODO adjust the cells to reflect the piece having moved
    selectedPiece = $(".selected-piece").closest(".game-piece")
    if $(".selected-piece").data("fast") == true && intermediate.length == 0 && $(".selected-piece").data("status") != "reserve"
      movePiece(selectedPiece, square)
      square.addClass("intermediate-square")
      clearHighlights()
      highlightAdjacentSquares($(this))
    else
      type = if selectedPiece.closest(".board-square").length == 0
        "Deploy"
      else
        "Move"

      $.post "/orders",
        type: type,
        pieceId: selectedPiece.data("id"),
        newRow: destination.data("row"),
        newColumn: destination.data("column"),
        intermediateRow: intermediate.data("row"),
        intermediateColumn: intermediate.data("column"),
        gameStub: gameStub
        (response)->
          movePiece(selectedPiece, square)
          processOrder($(".selected-piece").closest(".game-piece"), response)

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
        setPieceDirection(piece, direction)
        processOrder(piece, response)

  clearSelectedPieces = ->
    $(".selected-piece").removeClass("selected-piece")
    $(".intermediate-square").removeClass("intermediate-square")

  clearHighlights = ->
    $(".arrow").addClass("hide")
    $(".highlighted-square").removeClass("highlighted-square")

  processOrder = (piece, orderDescription) ->
    piece.children('a').addClass('disabled')
    $("#orders-list").append(orderDescription)
    $("#undo-order").removeClass('hide')
    clearSelectedPieces()
    clearHighlights()
    if $("#orders-list li").length == 3
      $("#confirm-orders").removeClass('hide')
      $(".game-piece a").addClass('disabled')

  setPieceDirection = (piece, direction) ->
    piece.removeClass("direction-"+piece.data("direction"))
    piece.addClass("direction-"+direction)
    piece.data("direction", direction)

  movePiece = (piece, square) ->
    square.append(piece.clone())
    piece.remove()
