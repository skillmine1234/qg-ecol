class AddAppIdToEcolVaTransfers < ActiveRecord::Migration
  def change
    add_column :ecol_va_transfers, :app_id, :string, :limit => 32, :comment => 'the identifier for the client to process a payment'    
    change_column :ecol_va_transfers, :rmtr_bene_note, :string, null: true
    remove_column :ecol_va_transfers, :cbs_ref_no, :string
    remove_column :ecol_va_transfers, :confirmed_at, :datetime
    change_column :ecol_va_transfers, :transfer_type, :string, null: true
    change_column :ecol_va_transfers, :status_code, :string, :limit => 32
    add_column :ecol_va_transfers, :rev_unblock_status, :string, :limit => 32, comment: 'the status of the reverse unblock'
    add_column :ecol_va_transfers, :rev_unblock_va_txn_id, :int, comment: 'the id of ecol_va_txns table which is required to show the transaction detail'
    add_column :ecol_va_transfers, :rev_unblock_fault_code, :string, :limit => 50, :comment => 'the code that identifies the exception, if an exception occured in the ESB while reversing the block'
    add_column :ecol_va_transfers, :rev_unblock_fault_subcode, :string, :limit => 50, :comment => 'the error code that the third party will return while reversing the block'
    add_column :ecol_va_transfers, :rev_unblock_fault_reason, :string, :limit => 1000, :comment => 'the english reason of the exception, if an exception occurred in the ESB while reversing the block'              

  end
end
