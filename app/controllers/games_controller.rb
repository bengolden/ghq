class GamesController < ApplicationController
  before_action :load_game, only: [:show, :update]

  def index
    @game = Game.new
  end

  def show
    @squares_under_fire = @game.squares_under_fire
  end

  def create
    @game = Game.create
    redirect_to game_path(@game.stub)
  end

  def update
    render json: @game.process_orders
  end

  private

  def load_game
    @game = Game.find_by(stub: params[:id])
  end
end
