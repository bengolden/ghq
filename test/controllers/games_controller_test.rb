require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  test "#index" do
    get :index
    assert_response :success
  end

  test "#show" do
    game = Game.create!
    byebug
    get game_path(game.stub)
    assert_response :success
  end

  test "#create" do
    post :create
    assert_equal 1, Game.count
    assert_redirected_to game_path(Game.last.stub)
  end
end
