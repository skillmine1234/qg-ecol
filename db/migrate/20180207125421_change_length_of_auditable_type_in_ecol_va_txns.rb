class ChangeLengthOfAuditableTypeInEcolVaTxns < ActiveRecord::Migration
  def change
    change_column :ecol_va_txns, :auditable_type, :string, limit: 50
  end
end
