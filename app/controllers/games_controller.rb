class GamesController < ApplicationController

  before_action :load_game, only: [:show, :update]

  def index

  end

  def show
    @squares_under_fire = @game.squares_under_fire    
  end

  def update
    @game.process_turn!
    render json: @game.squares_under_fire
  end

  private

  def load_game
    @game = Game.find_by(stub: params[:id])
  end

end
