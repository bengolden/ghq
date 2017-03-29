# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  gameStub = $(location).attr('pathname').replace("/games/","")

  $("#game-area").on "click", ".game-piece a", (e)->
    e.preventDefault()
    if $(".original-square").length > 0
      movedPiece = $(".intermediate-square .game-piece")
      movePiece(movedPiece, $(".original-square"))

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
        $(this).closest(".board-square").find(".arrow").removeClass("hide")

  $("#game-board").on "click", ".highlighted-square", (e)->
    e.preventDefault()
    destination = $(this)
    intermediate = $(".intermediate-square")
    selectedPiece = $(".selected-piece").closest(".game-piece")
    if $(".selected-piece").data("fast") == true && intermediate.length == 0 && $(".selected-piece").data("status") != "reserve"
      selectedPiece.closest(".board-square").addClass("original-square")
      movePiece(selectedPiece, destination)
      destination.addClass("intermediate-square")

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
          movePiece(selectedPiece, destination)
          processOrder($(".selected-piece").closest(".game-piece"), response)

  $("#game-board").on "click", ".board-square .arrow", (e)->
    e.preventDefault()
    piece = $(this).closest('.board-square').find(".game-piece")
    direction = $(this).data("direction")
    $.post "/orders",
      type: "Rotate",
      pieceId: piece.data("id"),
      newDirection: direction,
      gameStub: gameStub
      (response)->
        setPieceDirection(piece, direction)
        processOrder(piece, response)

  $("#confirm-orders").click (e)->
    e.preventDefault()
    $.post "/games/" + gameStub,
      _method: 'PUT'
      (response)->
        $("#orders-list li").remove()
        $("#turn-number").text( parseInt($("#turn-number").text()) + 1 )
        activePlayer = $("#active-player")
        $("#undo-order").addClass("hide")
        $("#confirm-orders").addClass("hide")
        $(".under-fire").removeClass("under-fire")
        $(".board-square").data("under-fire","false")

        $(response).each ->
          square = $(".board-square[data-row=" + this["row"] + "][data-column=" + this["column"] + "]")
          square.data("under-fire", "true")
          square.children(".inner-square").addClass("under-fire")

        if activePlayer.text() == "white"
          activePlayer.text("black")
        else
          activePlayer.text("white")
        $(".game-piece." + activePlayer.text() + "-piece a").removeClass('disabled')

  $("#undo-order").click (e)->
    e.preventDefault()
    lastOrder = $("#orders-list li").last()
    $.post "/orders/" + lastOrder.data("order-id"),
      _method: 'DELETE',
      gameStub: gameStub
      (response)->
        piece = $(".game-piece[data-id=" + response["piece_id"] + "]")
        if response["initial_direction"] == null
          destination = $(".board-square[data-row=" + response["initial_row"] + "][data-column=" + response["initial_column"] + "]")
          movePiece(piece, destination)
        else
          setPieceDirection(piece, response["initial_direction"])

        $("#confirm-orders").addClass('hide')
        lastOrder.remove()
        $(".game-piece." + $("#active-player").text() + "-piece a").removeClass('disabled')
        if $("#orders-list li").length == 0
          $("#undo-order").addClass('hide')

  clearSelectedPieces = ->
    $(".selected-piece").removeClass("selected-piece")
    $(".intermediate-square").removeClass("intermediate-square")
    $(".original-square").removeClass("original-square")

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
    if square.length == 0
      $(".row ." + $("#active-player").text() + "-pieces").append(piece.clone())
    else
      square.find(".inner-square").append(piece.clone())
      square.attr("data-empty", "false")
    piece.closest(".board-square").attr("data-empty", "true")
    piece.remove()

  highlightBackRow = (backRow) ->
    squares = $(".board-square[data-row='" + backRow + "'][data-empty='true'][data-under-fire='false']")
    squares.addClass("highlighted-square")

  highlightEmptySquares = ->
    squares = $(".board-square").filter -> $(this).data("empty") == true
    squares.addClass("highlighted-square")

  highlightAdjacentSquares = (piece) ->
    square = piece.closest(".board-square")
    row = square.data("row")
    column = square.data("column")
    squares = $(".board-square").filter -> $(this).data("row") >= row - 1 && $(this).data("row") <= row + 1 && $(this).data("column") >= column - 1 && $(this).data("column") <= column + 1 && ($(this).attr("data-empty") == "true" || $(this).hasClass("intermediate-square")) && $(this).data("under-fire") == false
    squares.addClass("highlighted-square")