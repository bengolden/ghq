# == Schema Information
#
# Table name: orders
#
#  id                  :integer          not null, primary key
#  type                :string
#  piece_id            :integer
#  turn_number         :integer
#  destination_row     :integer
#  destination_column  :integer
#  intermediate_row    :integer
#  intermediate_column :integer
#  final_direction     :integer
#  created_at          :datetime
#  updated_at          :datetime
#  initial_row         :integer
#  initial_column      :integer
#  initial_direction   :integer
#

class Rotate < Order

  before_create :set_initial_direction

  def process!
    piece.update(direction: final_direction)
  end

  def undo!
    piece.update(direction: initial_direction)
  end

  def to_s
    "#{piece.name} rotates to face #{final_direction}"
  end

  def set_initial_direction
    self.initial_direction = piece.direction
  end

end
