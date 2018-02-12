class CreateTableEcolVacdIncomingRecords < ActiveRecord::Migration
  def change
    create_table :ecol_vacd_incoming_records, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.integer :incoming_file_record_id, null: false, :comment => "the foreign key to the incoming_files table" 
      t.string :file_name, :limit => 100, null: false, :comment => "the name of the incoming_file" 
      t.string :account_no, :limit => 64, :null => false, :comment => "the virtual account no of a customer"
      t.number :txn_amount, :null => false, :comment => "the transaction amount"
      t.string :txn_type, :limit => 50, :null => false, :comment => "the type of transaction which make the change on virtual account no - ‘credit’ is for an incoming credit from e-collect, ‘debit’ is for payout to a real account, ‘earmark’ denotes a hold transaction"
      t.string :hold_no, :limit => 64, :comment => "the unique number which has been used to put the hold on a virtual account no"
      t.number :hold_amount, :default => 0, :comment => "the amount that is held, this is set or updated when a hold is placed"
      t.string :txn_desc, :limit => 255, :comment => "the description that consists the purpose of the transaction"                 
      t.index([:incoming_file_record_id,:file_name], :unique => true, :name => 'ecol_vacd_incoming_records_01')
    end
  end
end
