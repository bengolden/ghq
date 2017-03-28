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
  def range; 2; end

  def directions_to_turn
    Piece.directions.keys - [direction]
  end

  def squares_under_fire
    (1..range).map do |i|
      row = self.row + (i if facing?('s')).to_i - (i if facing?('n')).to_i
      column = self.column + (i if facing?('e')).to_i - (i if facing?('w')).to_i
      {row: row, column: column}
    end
  end

  def facing?(dir)
    direction.to_s.include?(dir)
  end

end
