module GamesHelper
  def show_undo_orders?
    @game.orders_this_turn.exists?
  end

  def show_confirm_orders?
    @game.orders_this_turn.count == 3
  end

  def show_undo_engagements?
    @game.engagements_this_turn.not_locked.exists?
  end

  def show_confirm_engagements?
    false
  end

  def square_classes(row, column)
    classes = ""
    classes += ' bottom-row' if row == 7
    classes += (row + column).even? ? ' light' : ' dark'
    classes
  end

  def piece_on_square(row, column)
    @game.pieces.find { |p| p.status == "active" && p.row == row && p.column == column }
  end

  def under_fire?(row, column)
    @squares_under_fire.include?(row: row, column: column)
  end
end
