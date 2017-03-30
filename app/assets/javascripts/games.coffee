$(document).ready ->
  gameStub = $(location).attr('pathname').replace("/games/","")

  $("#game-area").on "click", ".game-piece a", (e)->
    e.preventDefault()
    if $(".original-square").length > 0
      revertIncompleteMove($(this).closest(".game-piece").data("id"))
    square = $(this).closest(".board-square")
    clearSelectedPieces()
    clearHighlights()
    $(this).addClass("selected-piece")
    if $(this).attr("data-status") == "reserve"
      highlightBackRow()
    else if $(this).data('unit-type') == "paratrooper" && square.data("row").toString() == backRow()
      highlightEmptySquares()
    else
      highlightAdjacentSquares($(this))
      direction = $(this).attr("data-direction")
      if direction != null
        square.find(".arrow[data-direction!='" + direction + "']").removeClass('hide')

  $("#game-board").on "click", ".highlighted-square", (e)->
    e.preventDefault()
    destination = $(this)
    intermediate = $(".intermediate-square")
    selectedPiece = $(".selected-piece").closest(".game-piece")

    if $(".selected-piece").data("fast") == true && intermediate.length == 0 && $(".selected-piece").attr("data-status") != "reserve"
      selectedPiece.closest(".board-square").addClass("original-square")
      movePiece(selectedPiece, destination)
      destination.addClass("intermediate-square")

      clearHighlights()
      highlightAdjacentSquares($(this))
    else
      type = if selectedPiece.children("a").attr("data-status") == "reserve"
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
        $("#undo-order, #confirm-orders").addClass("hide")
        $(".under-fire").removeClass("under-fire")
        $(".board-square").attr("data-under-fire",false)

        $(response).each ->
          square = $(".board-square[data-row=" + this["row"] + "][data-column=" + this["column"] + "]")
          square.attr("data-under-fire", "true")
          square.children(".inner-square").addClass("under-fire")

        toggleActivePlayer()
        $(".game-piece." + activePlayer().text() + "-piece a").removeClass('disabled')

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
        $(".game-piece." + activePlayer().text() + "-piece a").removeClass('disabled')
        if $("#orders-list li").length == 0
          $("#undo-order").addClass('hide')

  activePlayer = ->
    $("#active-player")

  toggleActivePlayer = ->
    if activePlayer().text() == "white"
      activePlayer().text("black")
    else
      activePlayer().text("white")

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
    piece.removeClass("direction-" + piece.data("direction"))
    piece.addClass("direction-" + direction)
    piece.attr("data-direction", direction)
    piece.find("a").attr("data-direction", direction)

  movePiece = (piece, square) ->
    oldSquare = piece.closest(".board-square")
    arrows = oldSquare.find(".arrow")
    undoDeploy = square.length == 0
    if undoDeploy
      newSquare = $(".row ." + activePlayer().text() + "-pieces")
    else
      newSquare = square.find(".inner-square")
      square.attr("data-empty", "false")
    newSquare.append(arrows.clone())
    newSquare.append(piece.clone())
    newStatus = if undoDeploy then "reserve" else "active"
    newSquare.find(".game-piece a").attr("data-status", newStatus)

    oldSquare.attr("data-empty", "true")
    arrows.remove()
    piece.remove()

  revertIncompleteMove = (currentPieceId)->
    movedPiece = $(".intermediate-square .game-piece")
    if movedPiece.data("id") != currentPieceId
      movePiece(movedPiece, $(".original-square"))

  backRow = ->
    if $("#active-player").text() == "white" then '7' else '0'

  highlightBackRow = ->
    squares = $(".board-square[data-row='" + backRow() + "'][data-empty='true'][data-under-fire='false']")
    squares.addClass("highlighted-square")

  highlightEmptySquares = ->
    squares = $("#game-board .board-square").filter -> $(this).attr("data-empty") == "true" && $(this).attr("data-under-fire") != "true"
    squares.addClass("highlighted-square")

  highlightAdjacentSquares = (piece) ->
    square = piece.closest(".board-square")
    row = square.data("row")
    column = square.data("column")
    squares = $(".board-square").filter ->
      r = $(this).data("row")
      c = $(this).data("column")
      r >= row - 1 && r <= row + 1 && c >= column - 1 && c <= column + 1 && ($(this).attr("data-empty") == "true" || $(this).hasClass("intermediate-square")) && $(this).attr("data-under-fire") == "false"

    squares.addClass("highlighted-square")