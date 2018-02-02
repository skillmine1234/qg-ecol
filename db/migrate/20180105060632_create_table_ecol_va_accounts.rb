class CreateTableEcolVaAccounts < ActiveRecord::Migration
  def change
    create_table :ecol_va_accounts, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.string :account_no, :limit => 64, :null => false, :comment => "the virtual account no of a customer"
      t.string :customer_code, :limit => 20, :null => false, :comment => "the unique which has assigned to customer"
      t.number :account_balance, :null => false, :default => 0, :comment => "the available account balance for the virtual account no"
      t.number :hold_amount, :null => false, :default => 0, :comment => "the total hold amount on an account"
      t.string :app_id ,:limit => 50, :null => false, :comment => "the code or the name of the system that manages the virtual account"
      t.string :created_by, :limit => 20, :comment => "the person who creates the record"
      t.string :updated_by, :limit => 20, :comment => "the person who updates the record"
      t.datetime :created_at, :null => false, :comment => "the timestamp when the record was created"
      t.datetime :updated_at, :null => false, :comment => "the timestamp when the record was last updated"
      t.integer :lock_version, null: false, default: 0, comment: 'the version number of the record, every update increments this by 1' 
    end
    add_index :ecol_va_accounts, [:account_no], :unique => true, :name => :ecol_va_accounts_01
  end
end
