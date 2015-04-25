class RemoveColumnFromLatePlate < ActiveRecord::Migration
  def change
    remove_column :late_plates, :when
    add_column :late_plates, :t, :date_time
  end
end
