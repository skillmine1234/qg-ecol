class EcollectRequestTemplatesController < ApplicationController
  authorize_resource
  before_action :authenticate_user!
  before_action :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  # include EcollectRequestTemplateHelper

  def index
    # if params[:advanced_search].present?
    #   ecollect_request_templates = find_dp_esb_mappers(params).order("id DESC")
    # else
      # ecollect_request_templates = EcollectRequestTemplate.order("id desc")
      if params[:search] == "true"
        ecollect_request_templates = (params[:approval_status].present? and params[:approval_status] == 'U') ? EcollectRequestTemplate.unscoped.where("approval_status =? and client_code=?",'U',params[:client_code]).order("id desc") : EcollectRequestTemplate.where(approval_status: "A",client_code: params[:client_code]).order("id desc")
      else
      ecollect_request_templates = (params[:approval_status].present? and params[:approval_status] == 'U') ? EcollectRequestTemplate.unscoped.where("approval_status =?",'U').order("id desc") : EcollectRequestTemplate.where(approval_status: "A").order("id desc")
    end
    # end
    @ecollect_request_templates = ecollect_request_templates.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def new
    @ecollect_request_template = EcollectRequestTemplate.new
    @ecollect_request_template.ecollect_request_parameters.build
    @ecollect_request_template.ecollect_encrypt_decrypts.build
    @ecollect_request_template.ecollect_hash_templates.build
    @ecollect_request_template.ecollect_hash_parameters.build

    @ecollect_request_templates = EcollectRequestTemplate.where(client_code: params[:customer_code],step_name: params[:step_name] == "Validate" ? "VAL" : "NOT",approval_status: "A")
    @customer_code_exist = EcollectRequestTemplate.customer_code_exist(params[:customer_code])
  end

  def create
    @ecollect_request_template = EcollectRequestTemplate.new(ecollect_request_template_params)
    @customer_code_exist = EcollectRequestTemplate.customer_code_exist(params[:customer_code])
  #   if !@ecollect_request_template.valid?
  #     render "new"
  #   else
  #     @ecollect_request_template.created_by = current_user.id
  #     @ecollect_request_template.step_name = params[:step_name] == "Validate" ? "VAL" : "NOT"
  #     @ecollect_request_template.save!
  #     flash[:alert] = "ECollect Request Template created successfully"
  #     redirect_to @ecollect_request_template
  #   end
    if @customer_code_exist == true
      @ecollect_request_template.created_by = current_user.id
      @ecollect_request_template.step_name = params[:step_name] == "Validate" ? "VAL" : "NOT"
      @ecollect_request_template.api_type = params[:step_name] == "Validate" ? "VALIDATE" : "NOTIFY"
      if @ecollect_request_template.save
        flash[:alert] = "ECollect Request Template successfully created and is pending for approval"
        redirect_to @ecollect_request_template
      else
        render "new"
      end
    else
      flash[:alert] = "Customer Code doesn't exist so Request Template can't be created"
      redirect_to "/"
    end
  end

  def update
    @ecollect_request_template = EcollectRequestTemplate.unscoped.find_by_id(params[:id])
    @ecollect_request_template.attributes = params[:ecollect_request_template]
    @ecollect_request_template.approval_status = "U"
    if !@ecollect_request_template.valid?
      render "edit"
    else
      req_template_fields = ["client_code", "request", "request_type", "url", "api_type","step_name", "is_encryption_required", "is_hash_required"]
      request_template_changes = @ecollect_request_template.changes.keys
      track_ecol_req_changes = (req_template_fields & request_template_changes).any?
      if @ecollect_request_template.approval_status == 'U' && (current_user == @ecollect_request_template.created_user || (can? :edit, @ecollect_request_template))
        track_ecol_req_changes == true ? @ecollect_request_template.save! : @ecollect_request_template.save_without_auditing
        if @ecollect_request_template.is_hash_required == false && (@ecollect_request_template.ecollect_hash_templates.present? || @ecollect_request_template.ecollect_hash_parameters.present?)
          @ecollect_request_template.ecollect_hash_templates.delete_all
          @ecollect_request_template.ecollect_hash_parameters.delete_all
        end
        if @ecollect_request_template.is_encryption_required == false
          @ecollect_request_template.ecollect_encrypt_decrypts.delete_all if @ecollect_request_template.ecollect_encrypt_decrypts.present?
        end
        unapproved_record_exist = UnapprovedRecord.where(approvable_id: @ecollect_request_template.id, approvable_type: "EcollectRequestTemplate")
        UnapprovedRecord.create(approvable_id: @ecollect_request_template.id, approvable_type: "EcollectRequestTemplate") if unapproved_record_exist.blank?
        flash[:alert] = 'ECollect Request Template successfuly modified and is pending for approval'
        redirect_to @ecollect_request_template
      else
        flash[:notice] = "Sorry you don't have Privilege to Edit the ECollect Request Template!"
        redirect_to "/"
      end
    end
    rescue ActiveRecord::StaleObjectError
      @ecollect_request_template.reload
      flash[:alert] = 'Someone edited the code the same time you did. Please re-apply your changes to the code.'
      render "edit"
  end

  def edit
    @ecollect_request_template = EcollectRequestTemplate.unscoped.find_by_id(params[:id])
    if @ecollect_request_template.approval_status == "U"
      flash[:notice] = "ECollect Request Template is Pending for Approval so you can't edit it!"
      redirect_to "/"
    else
      @ecollect_request_template.ecollect_request_parameters.build if !@ecollect_request_template.ecollect_request_parameters.present?
      @ecollect_request_template.ecollect_encrypt_decrypts.build if !@ecollect_request_template.ecollect_encrypt_decrypts.present?
      @ecollect_request_template.ecollect_hash_templates.build if !@ecollect_request_template.ecollect_hash_templates.present?
      @ecollect_request_template.ecollect_hash_parameters.build if !@ecollect_request_template.ecollect_hash_parameters.present?
    end
  end

  def request_template_audit_logs
    @ecollect_request_template = EcollectRequestTemplate.unscoped.find(params[:id]) rescue nil
    @request_template_audit = @ecollect_request_template.audits[params[:version_id].to_i] rescue nil
  end

  def custom_approval_of_record
    @ecollect_request_template = EcollectRequestTemplate.find_by(id: params[:id])
    if @ecollect_request_template.approval_status == 'U' && (current_user == @ecollect_request_template.created_user || (can? :custom_approval_of_record, @ecollect_request_template))
      EcollectRequestTemplate.where(id: @ecollect_request_template.id).update_all(approval_status: "A")
      @ecollect_request_template.ecollect_hash_templates.where(approval_status: "U").update_all(approval_status: "A")
      @ecollect_request_template.ecollect_hash_parameters.where(approval_status: "U").update_all(approval_status: "A")
      @ecollect_request_template.ecollect_request_parameters.where(approval_status: "U").update_all(approval_status: "A")
      @ecollect_request_template.ecollect_encrypt_decrypts.where(approval_status: "U").update_all(approval_status: "A")
      UnapprovedRecord.where(approvable_id:  @ecollect_request_template.id, approvable_type: "EcollectRequestTemplate").delete_all

      flash[:alert] = "Ecollect Request Template Approved successfully"
      redirect_to unapproved_records_path(group_name: "e-collect",sc_service:"ECOL")
    else
      flash[:notice] = "Sorry you don't have Privilege to Approve the ECollect Request Template!"
      redirect_to "/"
    end
  end

  def show
    @ecollect_request_template = EcollectRequestTemplate.unscoped.find_by_id(params[:id])
  end

  private

  def ecollect_request_template_params
    params.require(:ecollect_request_template).permit(:client_code,:request,:request_type,:url,:is_encryption_required,:is_hash_required,:created_by,:updated_by,:api_type,:step_name,:approval_status,
                                              ecollect_encrypt_decrypts_attributes: [:id,:algorithm, :key, :parameter_type, :request_template_id, :secret_key, :created_by, :updated_by, :decrypt_response,:approval_status,:_destroy],
                                              ecollect_hash_templates_attributes: [:id,:checksum_type,:key,:parameter_type,:request,:request_template_id,:created_by,:updated_by,:approval_status,:_destroy],
                                              ecollect_hash_parameters_attributes: [:id, :format, :format_datatype,:request_template_id,:key,:parameter_type,:value,:value_type,:created_by,:updated_by,:custom_function,:approval_status,:_destroy],
                                              ecollect_request_parameters_attributes: [:id,:request_template_id, :format_datatype, :key, :parameter_type, :format, :value, :length, :created_by, :updated_by, :custom_function, :value_type,:approval_status,:_destroy])
  end

end