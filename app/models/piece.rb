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
  enum status: [:reserve, :active, :defeated]
  enum direction: [:n, :ne, :e, :se, :s, :sw, :w, :nw]

  before_create :set_direction
  scope :artillery, ->{ where(type: ["Artillery", "FastArtillery", "HeavyArtillery"]) }

  def artillery?; false; end
  def fast?; false; end
  def paratrooper?; false; end

  def set_direction
    self.direction = color == "black" ? :s : :n
  end

  def css_class
    type.to_s.underscore.gsub("_","-")
  end

  def name
    type.to_s.titleize
  end

end
