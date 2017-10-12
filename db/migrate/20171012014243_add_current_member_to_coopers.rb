class AddCurrentMemberToCoopers < ActiveRecord::Migration
  def change
    add_column :coopers, :current_member, :boolean
  end
end
