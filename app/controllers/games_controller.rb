class GamesController < ApplicationController

  before_action :load_game, only: [:show, :update]

  def index

  end

  def show
    @squares_under_fire = @game.squares_under_fire    
  end

  def update
    captured_pieces = @game.process_turn!
    render json: {under_fire: @game.squares_under_fire, captured: captured_pieces}
  end

  private

  def load_game
    @game = Game.find_by(stub: params[:id])
  end

end
