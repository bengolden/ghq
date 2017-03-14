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

class Order < ActiveRecord::Base
  belongs_to :piece

  scope :for_turn, ->(turn_number){ where(turn_number: turn_number) }

  enum final_direction: [:north, :northeast, :east, :southeast, :south, :southwest, :west, :northwest]
end
