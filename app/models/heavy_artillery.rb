# == Schema Information
#
# Table name: pieces
#
#  id            :integer          not null, primary key
#  type          :string
#  game_id       :integer
#  status        :integer
#  row           :integer
#  column        :integer
#  direction     :integer
#  color         :integer
#  created_at    :datetime
#  updated_at    :datetime
#  captured_turn :integer
#

class HeavyArtillery < Artillery
  def heavy?; true; end
  def range; 3; end
end
