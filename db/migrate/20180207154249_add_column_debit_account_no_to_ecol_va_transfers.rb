class AddColumnDebitAccountNoToEcolVaTransfers < ActiveRecord::Migration
  def change
    add_column :ecol_va_transfers, :debit_account_no, :string, limit: 20, null: false, comment: "the account to be debited"    
  end
end
