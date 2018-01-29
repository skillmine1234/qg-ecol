class ChangeLengthOfFileNameInEcolIncomingFiles < ActiveRecord::Migration
  def change
    change_column :ecol_incoming_files, :file_name, :string, limit: 100
  end
end
