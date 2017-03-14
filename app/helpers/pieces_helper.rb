module PiecesHelper

  def piece_classes(piece)
    "game-piece #{piece.color}-piece direction-#{piece.direction}"
  end
end