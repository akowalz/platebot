class RemoveColumnFromLatePlate < ActiveRecord::Migration
  def change
    remove_column :late_plates, :when
    add_column :late_plates, :t, :datetime
  end
end
