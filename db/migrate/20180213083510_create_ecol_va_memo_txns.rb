class CreateEcolVaMemoTxns < ActiveRecord::Migration
  def change
    create_table :ecol_va_memo_txns, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.string :reference_no, :limit => 255, :null => false, :comment => "the unique reference no for the transaction"
      t.string :account_no, :limit => 64, :null => false, :comment => "the virtual account no in of a customer"
      t.number :txn_amount, :null => false, :comment => "the transaction amount"
      t.string :hold_no, :limit => 64,:comment => "the unique number which has been used to put the hold on a virtual account no"
      t.string :txn_type, :limit => 50, :null => false, :comment => "the type of transaction which make the change on virtual account no - ‘credit’ is for an incoming credit from e-collect, ‘debit’ is for payout to a real account"
      t.string :txn_desc, :limit => 255, :comment => "the description that consists the purpose of the transaction"      
      t.number :hold_amount, :comment => "the total amount held after transaction"
      t.string :customer_code, limit: 20, null: false, comment: "the ecollect customer code assigned to this va transaction"
      t.integer :ecol_va_txn_id, comment: 'the id of the associated ecol_va_txns record'
      t.integer :ecol_va_earmark_id, comment: 'the id of the associated ecol_va_earmarks record'
      t.datetime :created_at, :null => false, comment: "the timestamp when the record was created"
      t.datetime :updated_at, :null => false, comment: "the timestamp when the record was last updated"
      t.string :created_by, limit: 20, comment: "the person who creates the record"
      t.string :updated_by, limit: 20, comment: "the person who updates the record"
      t.integer :lock_version, :null => false, default: 0, comment: "the version number of the record, every update increments this by 1"
      t.string :last_action, limit: 1, default: 'C', :null => false, comment: "the last action (create, update) that was performed on the record"
      t.string :approval_status, limit: 1, default: 'U', :null => false, comment: "the indicator to denote whether this record is pending approval or is approved"
      t.integer :approved_version, comment: "the version number of the record, at the time it was approved"
      t.integer :approved_id, comment: "the id of the record that is being updated"
      t.index([:reference_no, :approval_status], :unique => true, :name => 'ecol_va_memo_txns_01')
    end
  end
end
