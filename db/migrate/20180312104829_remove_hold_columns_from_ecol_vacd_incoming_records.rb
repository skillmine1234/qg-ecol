class RemoveHoldColumnsFromEcolVacdIncomingRecords < ActiveRecord::Migration
  def change
    remove_column :ecol_vacd_incoming_records, :hold_no
    remove_column :ecol_vacd_incoming_records, :hold_amount
  end
end
