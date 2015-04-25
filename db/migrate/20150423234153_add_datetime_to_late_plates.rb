class AddDatetimeToLatePlates < ActiveRecord::Migration
  def change
    remove_column :late_plates, :t
    add_column :late_plates, :dt, :DateTime
  end
end
