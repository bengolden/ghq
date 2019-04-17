class AddPhaseToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :phase, :integer, default: :orders
  end
end
