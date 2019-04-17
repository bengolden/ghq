# == Schema Information
#
# Table name: engagements
#
#  id              :integer          not null, primary key
#  game_id         :integer
#  turn_number     :integer
#  attacker_id     :integer
#  defender_id     :integer
#  locked          :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  defender_row    :integer
#  defender_column :integer
#  direction       :integer
#

class Engagement < ActiveRecord::Base
  belongs_to :game
  belongs_to :attacker, class_name: "Piece"
  belongs_to :defender, class_name: "Piece"

  before_create :set_turn_number
  after_create :set_location_and_direction

  enum direction: [:up, :down, :left, :right], _prefix: :direction

  private

  def set_turn_number
    self.turn_number = game.turn_number
  end

  def set_location_and_direction
    self.defender_row = defender.row
    self.defender_column = defender.column
    self.direction = if attacker_row < defender_row
                       :up
                     elsif attacker_row > defender_row
                       :down
                     elsif attacker_column < defender_column
                       :left
                     elsif attacker_column > defender_column
                       :right
                     end

    save
  end
end
