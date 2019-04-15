# == Schema Information
#
# Table name: engagements
#
#  id          :integer          not null, primary key
#  game_id     :integer
#  turn_number :integer
#  attacker_id :integer
#  defender_id :integer
#  locked      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Engagement < ActiveRecord::Base
  belongs_to :game
  belongs_to :attacker, class_name: "Piece"
  belongs_to :defender, class_name: "Piece"

  before_create :set_turn_number

  private

  def set_turn_number
    self.turn_number = game.turn_number
  end
end
