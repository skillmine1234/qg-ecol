class AddSmbColumnsToEcolCustomers < ActiveRecord::Migration
  def change
    add_column :ecol_customers, :sub_member_bank, :string, :limit => 1, :default => 'N'
    add_column :ecol_customers, :sub_member_bank_ifsc, :string
  end
end
