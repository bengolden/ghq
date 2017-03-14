class GamesController < ApplicationController

  def index
  end

  def show
    @game = Game.find_by_stub(params[:id])
  end

end
