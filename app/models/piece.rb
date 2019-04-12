# == Schema Information
#
# Table name: pieces
#
#  id         :integer          not null, primary key
#  type       :string
#  game_id    :integer
#  status     :integer
#  row        :integer
#  column     :integer
#  direction  :integer
#  color      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Piece < ActiveRecord::Base
  belongs_to :game
  has_many :orders, dependent: :destroy

  enum color: [:white, :black]
  enum status: [:reserve, :active, :captured]
  enum direction: [:n, :ne, :e, :se, :s, :sw, :w, :nw]

  before_create :set_direction
  scope :artillery, -> { where(type: ["Artillery", "FastArtillery", "HeavyArtillery"]) }
  scope :infantry, -> { where(type: ["Infantry", "FastInfantry", "Paratrooper"]) }

  attr_accessor :engaged

  def artillery?; false; end
  def infantry?; false; end
  def fast?; false; end
  def paratrooper?; false; end

  def get_captured
    update(row: nil, column: nil, status: :captured)
  end

  def set_direction
    self.direction = color == "black" ? :s : :n
  end

  def css_class
    type.to_s.underscore.gsub("_","-")
  end

  def name
    type.to_s.titleize
  end

  def unengaged?
    engaged.nil?
  end
end
