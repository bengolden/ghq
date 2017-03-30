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

class Paratrooper < Infantry
  def paratrooper?; true; end
end
