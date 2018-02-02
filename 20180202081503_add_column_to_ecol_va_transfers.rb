class AddColumnToEcolVaTransfers < ActiveRecord::Migration
  def change
    add_column :ecol_va_transfers, :ecol_va_txn_id, :int, comment: 'the id of ecol_va_txns tale which is required to show the transaction detail'                 
  end
end
