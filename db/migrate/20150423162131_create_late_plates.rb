class CreateLatePlates < ActiveRecord::Migration
  def change
    create_table :late_plates do |t|
      t.integer :cooper_id

      t.timestamps null: false
    end
  end
end
