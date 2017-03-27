class GamesController < ApplicationController

  before_action :load_game, only: [:show, :update]

  def index

  end

  def show
    
  end

  def update
    @game.process_turn!
  end

  private

  def load_game
    @game = Game.find_by(stub: params[:id])
  end

end
