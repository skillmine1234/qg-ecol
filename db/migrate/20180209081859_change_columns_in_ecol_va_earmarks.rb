class ChangeColumnsInEcolVaEarmarks < ActiveRecord::Migration
  def change
    remove_index :ecol_va_earmarks, name: 'ecol_va_earmarks_01'
    add_column :ecol_va_earmarks, :customer_code, :string, :limit => 20, :comment => "the customer code in E-Collect"
    change_column :ecol_va_earmarks, :customer_code, :string, null: false
    add_index :ecol_va_earmarks, [:account_no, :hold_no, :customer_code], unique: true, name: 'ecol_va_earmarks_01'
    remove_index :ecol_va_accounts, name: 'ecol_va_accounts_01'
    add_index :ecol_va_accounts, [:account_no, :customer_code], :unique => true, :name => 'ecol_va_accounts_01'
  end
end
