class CreatePhrases < ActiveRecord::Migration
  def change
    create_table :phrases do |t|
      t.integer :cooper_id
      t.string :text

      t.timestamps null: false
    end
  end
end
