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
end