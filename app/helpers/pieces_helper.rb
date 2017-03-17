module PiecesHelper

  def piece_classes(piece)
    "game-piece #{piece.color}-piece direction-#{piece.direction}"
  end

  def piece_data(piece)
    data = {
      toggle: "tooltip",
      unit_type: piece.css_class,
      status: piece.status,
      color: piece.color
    }
    if piece.artillery?
      data[:direction] = piece.direction
      data[:heavy] = piece.heavy?
    end
    data[:fast] = true if piece.fast?
    data[:paratrooper] = true if piece.paratrooper?
    data
  end

  def arrow_symbol(direction)
    {nw: "↖", n: "↑", ne: "↗", w: "←", e: "→", sw: "↙", s: "↓", se: "↘"}[direction.to_sym]
  end
end