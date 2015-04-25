class AddIndexOnNumberToCooper < ActiveRecord::Migration
  def change
    add_index :coopers, :number
  end
end
