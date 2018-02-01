class CreateTableEcolVaTxns < ActiveRecord::Migration
  def change
    create_table :ecol_va_txns, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.string :account_no, :limit => 64, :null => false, :comment => "the virtual account no in of a customer"
      t.string :hold_no, :limit => 64,:comment => "the unique number which has been used to put the hold on a virtual account no"
      t.string :txn_type, :limit => 50, :null => false, :comment => "the type of transaction which make the change on virtual account no - ‘credit’ is for an incoming credit from e-collect, ‘debit’ is for payout to a real account, ‘earmark’ denotes a hold transaction"
      t.datetime :txn_timestamp, :null => false, :comment => "the timestamp at which the transaction is created"
      t.number :txn_amount, :null => false, :comment => "the transaction amount"
      t.string :txn_desc, :limit => 255, :null => true, :comment => "the description that consists the purpose of the transaction"      
      t.number :account_balance, :null => false, :comment => "the available account balance after transaction"
      t.number :hold_amount, :null => false, :comment => "the total amount held after transaction"
      t.string :auditable_type, :limit => 20, :null => false, :comment => "the type of source that initiated the transaction"
      t.integer :auditable_id, :null => false, :comment => "the unique id of the source that initiated the transaction"
      t.string :created_by, :limit => 20, :comment => "the maker of the transaction if initiated from UI"
      t.string :approved_by, :limit => 20, :comment => "the checker of the transaction if initiated from UI"
     end
     add_index :ecol_va_txns, [:account_no, :txn_type,:auditable_type, :auditable_id], :unique => true, :name => 'ecol_va_txns_01'
  end
end
