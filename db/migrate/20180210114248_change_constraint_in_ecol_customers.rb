class ChangeConstraintInEcolCustomers < ActiveRecord::Migration
  def change
    if Rails.configuration.database_configuration[Rails.env]["adapter"] == 'oracle_enhanced'
      execute "ALTER TABLE ecol_customers DROP CONSTRAINT constraint_on_val_method"
      execute "ALTER TABLE ecol_customers ADD CONSTRAINT constraint_on_val_method CHECK (val_method IN ('D','W','N','V') )"
    end
  end
end
