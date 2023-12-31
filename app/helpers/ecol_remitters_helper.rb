module EcolRemittersHelper
  def filter_ecol_remitter(params)
    if params[:incoming_file_id].present?
      ecol_remitters = EcolRemitter.unscoped.where("incoming_file_id =?",params[:incoming_file_id]).order("id desc")
    else
      ecol_remitters = (params[:approval_status].present? and params[:approval_status] == 'U') ? EcolRemitter.unscoped.where("approval_status =?",'U').order("id desc") : EcolRemitter.order("id desc")
    end
    ecol_remitters
  end

  def find_ecol_remitters(remitters,params)
    ecol_remitters = remitters
    ecol_remitters = ecol_remitters.where("customer_code IN (?)",params[:customer_code].split(",").collect(&:strip)) if params[:customer_code].present?
    ecol_remitters = ecol_remitters.where("customer_subcode IN (?)",params[:customer_subcode].split(",").collect(&:strip)) if params[:customer_subcode].present?
    ecol_remitters = ecol_remitters.where("remitter_code IN (?)",params[:remitter_code].split(",").collect(&:strip)) if params[:remitter_code].present?
    ecol_remitters
  end

  def created_or_edited_by(resource)
    if resource.approval_status == 'U' and resource.approved_record.nil?
      "New Record Created By #{resource.created_user.try(:name)}"
    elsif resource.approval_status == 'U' and !resource.approved_record.nil?
      resource.updated_user.nil? ? "Record Edited By #{resource.created_user.try(:name)}" : "Record Edited By #{resource.updated_user.try(:name)}"
    end
  end
end