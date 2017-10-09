class AddActiveAndActivationCodeToCoopers < ActiveRecord::Migration
  def change
    add_column :coopers, :active, :boolean
    add_column :coopers, :activation_code, :string
  end
end
