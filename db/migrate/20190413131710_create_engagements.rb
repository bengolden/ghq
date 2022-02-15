class CreateEngagements < ActiveRecord::Migration[7.0]
  def change
    create_table :engagements do |t|
      t.integer :game_id
      t.integer :turn_number
      t.integer :attacker_id
      t.integer :defender_id
      t.boolean :locked

      t.timestamps
    end
  end
end
