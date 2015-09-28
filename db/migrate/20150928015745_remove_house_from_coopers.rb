class RemoveHouseFromCoopers < ActiveRecord::Migration
  def change
    remove_column :coopers, :house, :string
  end
end
