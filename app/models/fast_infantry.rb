# == Schema Information
#
# Table name: pieces
#
#  id                   :integer          not null, primary key
#  type                 :string
#  game_id              :integer
#  status               :integer
#  row                  :integer
#  column               :integer
#  direction            :integer
#  color                :integer
#  created_at           :datetime
#  updated_at           :datetime
#  captured_turn_number :integer
#

class FastInfantry < Infantry
  include FastPiece
end
