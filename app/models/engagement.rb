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
end
