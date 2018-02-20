class AddColumnsToEcolRemitters < ActiveRecord::Migration
  def change
  	add_column :ecol_remitters, :additional_email_ids, :string, :limit => 2000, :comment => "the additional email ids of the remitter"
    add_column :ecol_remitters, :additional_mobile_nos, :string, :limit => 500, :comment => "the additional mobile nos of the remitter"
  end
end
