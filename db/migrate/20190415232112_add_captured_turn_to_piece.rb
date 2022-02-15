class AddCapturedTurnToPiece < ActiveRecord::Migration[7.0]
  def change
    add_column :pieces, :captured_turn_number, :integer
  end
end
