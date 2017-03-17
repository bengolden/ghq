# == Schema Information
#
# Table name: pieces
#
#  id         :integer          not null, primary key
#  type       :string
#  game_id    :integer
#  status     :integer
#  row        :integer
#  column     :integer
#  direction  :integer
#  color      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Artillery < Piece
  def artillery?; true; end
  def heavy?; false; end

  def directions_to_turn
    Piece.directions.keys - [direction]
  end
end
