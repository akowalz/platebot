class AddWhenToLatePlate < ActiveRecord::Migration
  def change
    add_column :late_plates, :when, :time
  end
end
