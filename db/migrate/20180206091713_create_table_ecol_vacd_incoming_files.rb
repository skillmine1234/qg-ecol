class CreateTableEcolVacdIncomingFiles < ActiveRecord::Migration
  def change
    create_table :ecol_vacd_incoming_files, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.string :file_name, :limit => 100, :comment => 'the name of the incoming_file'
      t.index([:file_name], :unique => true, :name => 'ecol_vacd_incoming_files_01')   
    end
  end
end
