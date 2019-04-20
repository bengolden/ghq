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

class Deploy < Move
  def process!
    piece.update(status: :active, row: destination_row, column: destination_column)
  end

  def undo!
    piece.status = :reserve
    super
  end

  def to_s
    "#{piece.name} deploys to #{destination_square}"
  end
end
