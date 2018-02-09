class AddCustomerCodeToEcolVaTransfers < ActiveRecord::Migration
  def change
    add_column :ecol_va_transfers, :customer_code, :string, limit: 20, null: false, comment: "the ecollect customer code assigned to this va account"        
  end
end
