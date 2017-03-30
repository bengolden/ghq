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
#

class Game < ActiveRecord::Base
  include Concerns::Combat

  enum active_player: [:white, :black]
  has_many :pieces, dependent: :destroy
  has_many :orders, through: :pieces

  before_create :set_defaults
  before_create :create_pieces

  def process_turn!
    captured_pieces = attacker_pieces_under_fire
    resolve_artillery_combat!
    conduct_infantry_combat!

    if infantry_all_engaged?
      self.turn_number += 1
      toggle_active_player!
      self.save
    end

    captured_pieces.pluck(:id)
  end

  def squares_under_fire
    pieces.where(color: inactive_player).active.artillery.map(&:squares_under_fire).flatten.uniq
  end

  def inactive_player
    (active_player == "white") ? "black" : "white"
  end

  def toggle_active_player!
    self.active_player = inactive_player
  end

  def set_defaults
    self.stub = (0..9).map{ ('a'..'z').to_a.sample}.join
    self.active_player = "white"
    self.turn_number = 1
  end

  def create_pieces
    self.pieces << [Headquarters.new(status: "active", color: "white", column: 7, row: 7),
                    Headquarters.new(status: "active", color: "black", column: 0, row: 0),
                    Artillery.new(status: "active", color: "white", column: 6, row: 7),
                    Artillery.new(status: "active", color: "black", column: 1, row: 0)]
    3.times do |i|
      self.pieces << [Infantry.new(status: "active", color: "white", column: 7-i, row: 6),
                      Infantry.new(status: "active", color: "black", column: i, row: 1)]
    end

    [FastInfantry, FastInfantry, FastInfantry, FastArtillery, HeavyArtillery, Paratrooper].each do |klass|
      self.pieces << [klass.new(status: "reserve", color: "white"),
                      klass.new(status: "reserve", color: "black")]
    end

    6.times do
      self.pieces << [Infantry.new(status: "reserve", color: "white"),
                      Infantry.new(status: "reserve", color: "black")]
    end

    2.times do
      self.pieces << [Artillery.new(status: "reserve", color: "white"),
                      Artillery.new(status: "reserve", color: "black")]
    end

  end

  def orders_this_turn
    orders.for_turn(turn_number)
  end
end
