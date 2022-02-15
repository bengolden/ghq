class AddPieces < ActiveRecord::Migration[7.0]
  def change
    create_table :pieces do |t|
      t.string :type
      t.integer :game_id
      t.integer :status
      t.integer :row
      t.integer :column
      t.integer :direction
      t.integer :color

      t.timestamps
    end
  end
end
