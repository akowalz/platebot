class CreateCoopers < ActiveRecord::Migration
  def change
    create_table :coopers do |t|
      t.string :name
      t.string :number

      t.timestamps null: false
    end
  end
end
