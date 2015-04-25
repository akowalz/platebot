class AddColumnToLatePlates < ActiveRecord::Migration
  def change
    remove_column :late_plates, :t
    add_column :late_plates, :t, :Time
  end
end
