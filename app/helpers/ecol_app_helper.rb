module EcolAppHelper

  def find_ecol_apps(params)
    ecol_apps = (params[:approval_status].present? and params[:approval_status] == 'U') ? EcolApp.unscoped : EcolApp
    ecol_apps = ecol_apps.where("app_code IN (?)",params[:app_code].split(",").collect(&:strip)) if params[:app_code].present?
    ecol_apps = ecol_apps.where("customer_code IN (?)",params[:customer_code].split(",").collect(&:strip)) if params[:customer_code].present?
    ecol_apps
  end

end