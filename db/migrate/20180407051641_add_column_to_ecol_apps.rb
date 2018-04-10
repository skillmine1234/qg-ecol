class AddColumnToEcolApps < ActiveRecord::Migration
  def change
    add_column :ecol_apps, :protocol_version, :string, limit: 10, comment: 'protocol version of the ssl'
  end
end
