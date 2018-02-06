class AddVirtualAccountNoToEcolCustomers < ActiveRecord::Migration
  def change
    add_column :ecol_transactions, :va_txn_id, :integer, :comment => 'the id of ecol_va_txns table'
    add_column :ecol_transactions, :va_transfer_status, :string, limit: 20, :comment => 'the status of credit in virtual account'      
  end
end
