class AddSmsConfirmationCodeAndSmsConfirmedToCoopers < ActiveRecord::Migration
  def change
    add_column :coopers, :sms_confirmation_code, :string
    add_column :coopers, :sms_confirmed, :boolean
  end
end
