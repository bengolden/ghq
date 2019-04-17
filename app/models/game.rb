# == Schema Information
#
# Table name: games
#
#  id            :integer          not null, primary key
#  turn_number   :integer
#  active_player :integer
#  stub          :string
#  created_at    :datetime
#  updated_at    :datetime
#  phase         :integer
#

class Game < ActiveRecord::Base
  include Concerns::Combat

  enum active_player: [:white, :black]
  enum phase: [:orders, :engagements], _prefix: :phase
  has_many :pieces, dependent: :destroy
  has_many :orders, through: :pieces
  has_many :engagements, dependent: :destroy

  before_create :set_defaults
  before_create :create_pieces

  def process_orders
    resolve_artillery_combat!

    conduct_infantry_combat
    resolve_infantry_combat!

    if infantry_all_engaged?
      process_turn!
    else
      initiate_engagements_phase
    end
  end

  def process_turn!
    self.turn_number += 1
    toggle_active_player!
    phase_orders!
    save

    { process_turn: true, captured_pieces: @captured_pieces.map(&:id) }
  end

  def initiate_engagements_phase
    phase_engagements!

    {
      process_engagements: true,
      engagements: engagements.map { |e| e.attributes.slice("defender_row", "defender_column", "direction") }
    }
  end

  def squares_under_fire
    pieces.where(color: inactive_player).active.artillery.map(&:squares_under_fire).flatten.uniq
  end

  def inactive_player
    active_player == "white" ? "black" : "white"
  end

  def toggle_active_player!
    self.active_player = inactive_player
  end

  def orders_this_turn
    orders.for_turn(turn_number)
  end

  private

  def set_defaults
    self.stub = (0..9).map { ('a'..'z').to_a.sample }.join
    self.active_player = "white"
    self.turn_number = 1
  end

  def create_pieces
    create_active_pieces
    create_unique_pieces

    6.times do
      pieces << [Infantry.new(status: "reserve", color: "white"),
                 Infantry.new(status: "reserve", color: "black")]
    end

    2.times do
      pieces << [Artillery.new(status: "reserve", color: "white"),
                 Artillery.new(status: "reserve", color: "black")]
    end
  end

  def create_active_pieces
    pieces << [Headquarters.new(status: "active", color: "white", column: 7, row: 7),
               Headquarters.new(status: "active", color: "black", column: 0, row: 0),
               Artillery.new(status: "active", color: "white", column: 6, row: 7),
               Artillery.new(status: "active", color: "black", column: 1, row: 0)]
    3.times do |i|
      pieces << [Infantry.new(status: "active", color: "white", column: 7 - i, row: 6),
                 Infantry.new(status: "active", color: "black", column: i, row: 1)]
    end
  end

  def create_unique_pieces
    [FastInfantry, FastInfantry, FastInfantry, FastArtillery, HeavyArtillery, Paratrooper].each do |klass|
      pieces << [klass.new(status: "reserve", color: "white"),
                 klass.new(status: "reserve", color: "black")]
    end
  end
end
