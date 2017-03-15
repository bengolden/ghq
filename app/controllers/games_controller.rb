class GamesController < ApplicationController

  def index
  end

  def show
    @game = Game.find_by(stub: params[:id])
  end

end
