class AddCustomerCodeToEcolVaTxns < ActiveRecord::Migration
  def change
    add_column :ecol_va_txns, :customer_code, :string, limit: 20, comment: "the ecollect customer code assigned to this va transaction"
    change_column :ecol_va_txns, :customer_code, :string, null: false
    remove_index :ecol_va_txns, name: 'ecol_va_txns_01'
    add_index :ecol_va_txns, [:customer_code, :account_no, :hold_no, :txn_type, :txn_timestamp], name: 'ecol_va_txns_01'
  end
end
