class AddInitialDataToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :initial_row, :integer
    add_column :orders, :initial_column, :integer
    add_column :orders, :initial_direction, :integer
  end
end
