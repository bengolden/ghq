class OrdersController < ApplicationController

  before_action :load_game

  def create
    game = Game.find_by(stub: params["gameStub"])
    piece = @game.pieces.find(params["pieceId"])
    raise unless allowed_order_types.include? params["type"]

    order = params["type"].constantize.create(piece: piece,
                                              turn_number: @game.turn_number,
                                              final_direction: params["newDirection"],
                                              destination_row: params["newRow"],
                                              destination_column: params["newColumn"],
                                              intermediate_row: params["intermediateRow"],
                                              intermediate_column: params["intermediateColumn"]
                                              )
    order.process!
    render partial: "games/order", locals: {order: order}
  end

  def destroy
    order = @game.orders.find_by(id: params[:id])
    order.undo!
    order.destroy

    render json: order.undo_attributes
  end

  private

  def load_game
    @game = Game.find_by(stub: params["gameStub"])
  end

  def allowed_order_types
    ["Move", "Rotate", "Deploy"]
  end

end
