class AddAdminToCoopers < ActiveRecord::Migration
  def change
    add_column :coopers, :admin, :boolean
  end
end
