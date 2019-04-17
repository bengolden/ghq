class AddRowColumnDirectionToEngagement < ActiveRecord::Migration[5.0]
  def change
    add_column :engagements, :defender_row, :integer
    add_column :engagements, :defender_column, :integer
    add_column :engagements, :direction, :integer
  end
end
