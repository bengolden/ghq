class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :type
      t.integer :piece_id
      t.integer :turn_number
      t.integer :destination_row
      t.integer :destination_column
      t.integer :intermediate_row
      t.integer :intermediate_column
      t.integer :final_direction

      t.timestamps
    end
  end
end
