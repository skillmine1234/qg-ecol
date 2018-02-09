class ChangeIndexInEcolVaEarmarks < ActiveRecord::Migration
  def change
    remove_index :ecol_va_earmarks, name: 'ecol_va_earmarks_01'
    add_index :ecol_va_earmarks, [:account_no, :hold_no], unique: true, name: 'ecol_va_earmarks_01'
    remove_column :ecol_va_earmarks, :customer_code
  end
end
