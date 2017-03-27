class OrdersController < ApplicationController

  def create
    game = Game.find_by(stub: params["gameStub"])
    piece = game.pieces.find(params["pieceId"])
    raise unless allowed_order_types.include? params["type"]

    order = params["type"].constantize.create(piece: piece,
                                              turn_number: game.turn_number,
                                              final_direction: params["newDirection"],
                                              destination_row: params["newRow"],
                                              destination_column: params["newColumn"]
                                              )
    order.process!
    render partial: "games/order", locals: {order: order}
  end

  def destroy
    
  end

  def allowed_order_types
    ["Move", "Rotate", "Deploy"]
  end

end
