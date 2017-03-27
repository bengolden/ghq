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

class Move < Order

  def to_s
    text = "#{piece.name} moves to #{destination_cell}"
    text += " via #{intermediate_cell}" if intermediate_row.present?
    text
  end

  def destination_cell
    cell(destination_row, destination_column)
  end

  def intermediate_cell
    cell(intermediate_row, intermediate_column)
  end

  def cell(row, column)
    ("A".."H").to_a[column] + (row + 1).to_s
  end

end
