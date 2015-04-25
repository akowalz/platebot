class UpdateCooper < ActiveRecord::Migration
  def change
    remove_column :coopers, :name
    add_column :coopers, :fname, :string
    add_column :coopers, :lname, :string
    add_column :coopers, :house, :string
  end
end
