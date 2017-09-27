class CreateEcolIncomingFiles < ActiveRecord::Migration
  def change
    create_table :ecol_incoming_files, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|      
      t.string :file_name, :limit => 100, :comment => "the name of the incoming_file"    
      t.string :customer_id, :limit => 20, :comment => "the customer code for the remitter"
      t.string :file_upld_mthd, :limit => 1, :comment => "the upload method for the file e.g. either upload the remitter file with existing customers remitter or delete the existing remitter for the customer then upload"
      t.index([:file_name], :unique => true, :name => 'ecol_incoming_files_01')
    end
  end
end
