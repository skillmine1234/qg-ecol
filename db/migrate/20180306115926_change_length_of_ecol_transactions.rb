class ChangeLengthOfEcolTransactions < ActiveRecord::Migration
  def change
   change_column :ecol_transactions, :rmtr_sms_notify_ref, :string, limit: 2000
  end
end
