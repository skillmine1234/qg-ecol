class ChangeLengthOfUrlsInEcolApps < ActiveRecord::Migration
  def change
    change_column :ecol_apps, :validate_url, :string, limit: 500
    change_column :ecol_apps, :notify_url, :string, limit: 500
  end
end
