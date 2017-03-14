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
#

class Move < Order

  def to_s
    text = "#{piece.name} moves to row #{destination_row}, column #{destination_column}"
    text += " via row #{intermediate_row}, column #{intermediate_column}" if intermediate_row.present?
    text
  end

end
