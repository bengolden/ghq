class AddCapturedTurnToPiece < ActiveRecord::Migration[5.0]
  def change
    add_column :pieces, :captured_turn_number, :integer
  end
end
