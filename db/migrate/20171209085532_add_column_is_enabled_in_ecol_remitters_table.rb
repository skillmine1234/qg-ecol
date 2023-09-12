class AddColumnIsEnabledInEcolRemittersTable < ActiveRecord::Migration
  def change
    add_column :ecol_remitters, :is_enabled, :string, limit: 1, default: 'Y', null: false, comment: 'the flag which indicates whether the ecol_remitter record is enabled or not'
  end
end
