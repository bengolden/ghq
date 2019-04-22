class AddPhaseToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :phase, :integer, default: 0
  end
end
