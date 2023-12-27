module EcolAppHelper

  def find_ecol_apps(params)
    ecol_apps = (params[:approval_status].present? and params[:approval_status] == 'U') ? EcolApp.unscoped : EcolApp
    ecol_apps = ecol_apps.where("LOWER(app_code) LIKE ?", "%#{params[:app_code].downcase}%") if params[:app_code].present?
    ecol_apps = ecol_apps.where("LOWER(customer_code) LIKE ?", "%#{params[:customer_code].downcase}%") if params[:customer_code].present?
    ecol_apps
  end

end