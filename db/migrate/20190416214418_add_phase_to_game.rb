class AddPhaseToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :phase, :integer, default: 0
  end
end
