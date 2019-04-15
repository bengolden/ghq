# == Schema Information
#
# Table name: pieces
#
#  id            :integer          not null, primary key
#  type          :string
#  game_id       :integer
#  status        :integer
#  row           :integer
#  column        :integer
#  direction     :integer
#  color         :integer
#  created_at    :datetime
#  updated_at    :datetime
#  captured_turn :integer
#

class Piece < ActiveRecord::Base
  belongs_to :game
  has_many :orders, dependent: :destroy
  has_many :attacker_engagements, class_name: "Engagement", foreign_key: :attacker_id
  has_many :defender_engagements, class_name: "Engagement", foreign_key: :defender_id

  enum color: [:white, :black]
  enum status: [:reserve, :active, :captured]
  enum direction: [:n, :ne, :e, :se, :s, :sw, :w, :nw]

  before_create :set_direction
  scope :artillery, -> { where(type: ["Artillery", "FastArtillery", "HeavyArtillery"]) }
  scope :infantry, -> { where(type: ["Infantry", "FastInfantry", "Paratrooper"]) }

  def artillery?; false; end
  def infantry?; false; end
  def fast?; false; end
  def paratrooper?; false; end

  def become_captured
    update(row: nil, column: nil, status: :captured, captured_turn_number: game.turn_number)
  end

  def set_direction
    self.direction = color == "black" ? :s : :n
  end

  def css_class
    type.to_s.underscore.gsub("_", "-")
  end

  def name
    type.to_s.titleize
  end

  def engaged?
    attacker_engagements.where(turn_number: game.turn_number).exists? ||
      defender_engagements.where(turn_number: game.turn_number).exists?
  end

  def unengaged?
    !engaged?
  end
end
