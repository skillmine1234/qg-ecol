class AddVirtualAccountNoToEcolCustomers < ActiveRecord::Migration
  def change
    add_column :ecol_transactions, :virtual_account_no, :string, limit: 64, :comment => "the virtual account no of an ecollect customer"    
  end
end
