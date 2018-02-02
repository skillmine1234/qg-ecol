class CreateEcolVaPendingTransfers < ActiveRecord::Migration
  def change
    create_table :ecol_va_pending_transfers, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.string :broker_uuid, :limit => 255, :null => false, :comment => "the UUID of the broker"
      t.integer :ecol_va_transfer_id, :null => false, :comment => "the id of the row that represents the request that is related to this record"
      t.datetime :created_at, :null => false, :comment => "the timestamp when the record was created" 
      t.datetime :updated_at, :null => false, :comment => "the timestamp when the record was updated" 
      t.index([:broker_uuid, :created_at], :name => 'ecol_va_pending_transfers_01')
    end
  end
end
