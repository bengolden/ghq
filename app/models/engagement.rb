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
  include Location

  belongs_to :game
  belongs_to :attacker, class_name: "Piece"
  belongs_to :defender, class_name: "Piece"

  before_create :set_turn_number
  after_create :set_location
  after_create :set_direction

  scope :for_turn, ->(turn_number) { where(turn_number: turn_number) }
  scope :not_locked, -> { where.not(locked: true) }

  enum direction: [:up, :down, :left, :right], _prefix: :direction

  def to_s
    "#{piece_on_square(attacker)} engages #{piece_on_square(defender)}"
  end

  def piece_on_square(piece)
    "#{piece.name} on #{square(piece.row, piece.column)}"
  end

  private

  def set_turn_number
    self.turn_number = game.turn_number
  end

  def set_location
    update(defender_row: defender.row, defender_column: defender.column)
  end

  def set_direction
    self.direction = if attacker.row < defender.row
                       :up
                     elsif attacker.row > defender.row
                       :down
                     elsif attacker.column < defender.column
                       :left
                     elsif attacker.column > defender.column
                       :right
                     end

    save
  end
end
