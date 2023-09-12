class AddApprovalColumnsToEcolTransactions < ActiveRecord::Migration
  def change
    add_column :ecol_transactions, :approval_status, :string, :limit => 1, :default => 'N', :null => false
    add_column :ecol_transactions, :last_action, :string, :limit => 1, :default => 'C'
    add_column :ecol_transactions, :approved_version, :integer
    add_column :ecol_transactions, :approved_id, :integer
  end
end
