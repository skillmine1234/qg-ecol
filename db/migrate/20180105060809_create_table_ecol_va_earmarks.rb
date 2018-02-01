class CreateTableEcolVaEarmarks < ActiveRecord::Migration
  def change
    create_table :ecol_va_earmarks, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.string :account_no, :limit => 64, :null => false , :comment => "the virtual account no in E-Collect"
      t.string :customer_code, :limit => 20, :null => false, :comment => "the customer code in E-Collect"
      t.string :hold_no, :limit => 120, :null => false, :comment => "the reference number which is used to identify the hold that is to be released or updated"
      t.number :hold_amount, :null => false, :default => 0, :comment => "the amount that is held, this is set or updated when a hold is placed"
      t.string :hold_desc, :limit => 255, :null => false, :comment => "the description which consists the purpose of hold"
      t.datetime :created_at, :null => false, :comment => "the timestamp at which the hold is created"
      t.datetime :updated_at, :null => false, :comment => "the timestamp at which the hold was last updated"
    end
    add_index :ecol_va_earmarks, [:hold_no], :unique => true, :name => :ecol_va_earmarks_01
  end
end
