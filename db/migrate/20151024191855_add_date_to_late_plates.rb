class AddDateToLatePlates < ActiveRecord::Migration
  def change
    add_column :late_plates, :date, :Date
  end
end
