class AddColumnToEcolVaTransfers < ActiveRecord::Migration
  def change
    add_column :ecol_va_transfers, :ecol_va_txn_id, :int, comment: 'the id of ecol_va_txns tale which is required to show the transaction detail'                 
    add_column :ecol_va_transfers, :customer_id, :string, limit: 50, comment: 'the customer id of an ecollect customer'       
    add_column :ecol_va_transfers, :fault_code, :string, :limit => 50, :comment => 'the code that identifies the exception, if an exception occured in the ESB'
    add_column :ecol_va_transfers, :fault_subcode, :string, :limit => 50, :comment => "the error code that the third party will return"
    add_column :ecol_va_transfers, :fault_reason, :string, :limit => 1000, :comment => 'the english reason of the exception, if an exception occurred in the ESB'              
  end
end
