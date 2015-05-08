class CreateRepeatPlates < ActiveRecord::Migration
  def change
    create_table :repeat_plates do |t|
      t.integer :day
      t.integer :cooper_id

      t.timestamps null: false
    end
  end
end
