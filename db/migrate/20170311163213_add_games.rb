class AddGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :turn_number
      t.integer :active_player
      t.string :stub
 
      t.timestamps
    end

  end
end
