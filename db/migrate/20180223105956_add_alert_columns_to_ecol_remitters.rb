class AddAlertColumnsToEcolRemitters < ActiveRecord::Migration
  def change
    add_column :ecol_remitters, :additional_mobile_nos, :string, limit: 255, comment: 'the additional mobile numbers to which alert needs to be sent'
    add_column :ecol_remitters, :additional_email_ids, :string, limit: 255, comment: 'the additional email ids to which alert needs to be sent'
  end
end
