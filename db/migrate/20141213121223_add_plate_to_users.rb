class AddPlateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :plate, :string
    add_index :users, :plate
  end
end
