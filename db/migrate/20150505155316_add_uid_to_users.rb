class AddUidToUsers < ActiveRecord::Migration
  def change
    add_column :coopers, :uid, :string
  end
end
