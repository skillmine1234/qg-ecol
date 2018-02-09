class AddColumnsToEcolVaTransfers < ActiveRecord::Migration
  def change
    add_column :ecol_va_transfers, :debit_account_no, :string, limit: 20, comment: "the account to be debited"
    change_column :ecol_va_transfers, :debit_account_no, :string, null: false
    add_column :ecol_va_transfers, :customer_code, :string, limit: 20, comment: "the ecollect customer code assigned to this va account"
    change_column :ecol_va_transfers, :customer_code, :string, null: false
  end
end
