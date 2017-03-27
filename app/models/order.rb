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

class Order < ActiveRecord::Base
  belongs_to :piece

  scope :for_turn, ->(turn_number){ where(turn_number: turn_number) }

  enum final_direction: [:n, :ne, :e, :se, :s, :sw, :w, :nw], _prefix: :final
  enum initial_direction: [:n, :ne, :e, :se, :s, :sw, :w, :nw], _prefix: :initial

  def undo_attributes
    {piece_id: piece_id, initial_row: initial_row, initial_column: initial_column, initial_direction: initial_direction}
  end

end
