class OrdersController < ApplicationController

  def create
    game = Game.find_by(stub: params["gameStub"])
    piece = game.pieces.find(params["pieceId"])
    raise unless allowed_order_types.include? params["type"]
    order = params["type"].constantize.create(piece: piece, final_direction: params["newDirection"], turn_number: game.turn_number)
    order.process!
    render partial: "games/order", locals: {order: order}
  end

  def destroy
    
  end

  def allowed_order_types
    ["Move", "Rotate", "Deploy"]
  end

end
