module GamesHelper

  def show_undo_orders?
    @game.orders_this_turn.exists?
  end

  def show_confirm_orders?
    @game.orders_this_turn.count == 3
  end

  def square_classes(r,c)
    classes = ""
    classes +=' bottom-row' if r == 7
    classes += (r+c).even? ? ' light' : ' dark'
    classes
  end

  def piece_on_square(r,c)
    @game.pieces.find{|p| p.status == "active" && p.row == r && p.column == c}
  end

  def under_fire?(r,c)
    @squares_under_fire.include?({row: r, column: c})
  end
end
