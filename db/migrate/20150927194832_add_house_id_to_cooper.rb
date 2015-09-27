class AddHouseIdToCooper < ActiveRecord::Migration
  def change
    add_column :coopers, :house_id, :integer
  end
end
