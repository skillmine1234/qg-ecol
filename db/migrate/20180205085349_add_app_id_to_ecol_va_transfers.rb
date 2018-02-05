class AddAppIdToEcolVaTransfers < ActiveRecord::Migration
  def change
    add_column :ecol_va_transfers, :app_id, :string, :limit => 32, :comment => 'the identifier for the client to process a payment'    
    change_column :ecol_va_transfers, :rmtr_bene_note, :string, null: true
    remove_column :ecol_va_transfers, :cbs_ref_no, :string
    remove_column :ecol_va_transfers, :confirmed_at, :datetime
    change_column :ecol_va_transfers, :transfer_type, :string, null: true
  end
end
