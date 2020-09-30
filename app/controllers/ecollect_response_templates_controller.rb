class EcollectResponseTemplatesController < ApplicationController
	authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  # include EcollectResponseTemplateHelper

  def index
    # if params[:advanced_search].present?
    #   ecollect_request_templates = find_dp_esb_mappers(params).order("id DESC")
    # else
      ecollect_response_templates = (params[:approval_status].present? and params[:approval_status] == 'U') ? EcollectResponseTemplate.unscoped.where("approval_status =?",'U').order("id desc") : EcollectResponseTemplate.where(approval_status: "A").order("id desc")
    # end
    @ecollect_response_templates = ecollect_response_templates.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

	def new
    @ecollect_response_template = EcollectResponseTemplate.new
    @ecollect_response_template.ecol_resp_parameters.build
    @ecollect_response_template.ecol_resp_matrices.build

    # @ecollect_response_templates = EcollectResponseTemplate.where(client_code: params[:customer_code],step_name: params[:step_name] == "Validate" ? "VAL" : "NOT",approval_status: "A")
    @customer_code_exist = EcollectRequestTemplate.customer_code_exist(params[:customer_code])
	end

  def create
    @ecollect_response_template = EcollectResponseTemplate.new(ecollect_response_template_params)
    @customer_code_exist = EcollectRequestTemplate.customer_code_exist(params[:customer_code])
  #   if !@ecollect_response_template.valid?
  #     render "new"
  #   else
  #     @ecollect_response_template.created_by = current_user.id
  #     @ecollect_response_template.step_name = params[:step_name] == "Validate" ? "VAL" : "NOT"
  #     @ecollect_response_template.save!
  #     flash[:alert] = "ECollect Response Template created successfully"
  #     redirect_to @ecollect_response_template
  #   end
    if @customer_code_exist == true
      @ecollect_response_template.created_by = current_user.id
      @ecollect_response_template.step_name = params[:step_name] == "Validate" ? "VAL" : "NOT"
      @ecollect_response_template.api_type = params[:step_name] == "Validate" ? "VALIDATE" : "NOTIFY"
      if @ecollect_response_template.save
        flash[:alert] = "ECollect Response Template successfully created and is pending for approval"
        redirect_to @ecollect_response_template
      else
        render "new"
      end
    else
      flash[:alert] = "Customer Code doesn't exist so Response Template can't be created"
      redirect_to "/"
    end
  end

	def update
    @ecollect_response_template = EcollectResponseTemplate.unscoped.find_by_id(params[:id])
    @ecollect_response_template.attributes = params[:ecollect_response_template]
    @ecollect_response_template.approval_status = "U"
    if !@ecollect_response_template.valid?
      render "edit"
    else
      resp_template_fields = ["client_code", "response_code", "api_type", "request_template_id", "step_name","is_error_flag"]
      resp_template_changes = @ecollect_response_template.changes.keys
      track_ecol_resp_changes = (resp_template_fields & resp_template_changes).any?
      if @ecollect_response_template.approval_status == 'U' && (current_user == @ecollect_response_template.created_user || (can? :edit, @ecollect_response_template))
        track_ecol_resp_changes == true ? @ecollect_response_template.save! : @ecollect_response_template.save_without_auditing
        unapproved_record_exist = UnapprovedRecord.where(approvable_id: @ecollect_response_template.id, approvable_type: "EcollectResponseTemplate")
        UnapprovedRecord.create(approvable_id: @ecollect_response_template.id, approvable_type: "EcollectResponseTemplate") if unapproved_record_exist.blank?
        flash[:alert] = 'ECollect Response Template modified successfully'
        redirect_to @ecollect_response_template
      else
        flash[:notice] = "Sorry you don't have Privilege to Edit the ECollect Response Template!"
        redirect_to "/"
      end
    end
    rescue ActiveRecord::StaleObjectError
      @ecollect_response_template.reload
      flash[:alert] = 'Someone edited the code the same time you did. Please re-apply your changes to the code.'
      render "edit"
  end

  def edit
    @ecollect_response_template = EcollectResponseTemplate.unscoped.find_by_id(params[:id])
    if @ecollect_response_template.approval_status == "U"
      flash[:notice] = "ECollect Response Template is Pending for Approval so you can't edit it!"
      redirect_to "/"
    else
      @ecollect_response_template.ecol_resp_parameters.build if !@ecollect_response_template.ecol_resp_parameters.present?
      @ecollect_response_template.ecol_resp_matrices.build if !@ecollect_response_template.ecol_resp_matrices.present?
    end
  end

  def response_template_audit_logs
    @ecollect_response_template = EcollectResponseTemplate.unscoped.find(params[:id]) rescue nil
    @response_template_audit = @ecollect_response_template.audits[params[:version_id].to_i] rescue nil
  end

  def custom_approval_of_record
    @ecollect_response_template = EcollectResponseTemplate.find_by(id: params[:id])
    if @ecollect_response_template.approval_status == 'U' && (current_user == @ecollect_response_template.created_user || (can? :custom_approval_of_record, @ecollect_response_template))
      EcollectResponseTemplate.where(id: @ecollect_response_template.id).update_all(approval_status: "A")
      @ecollect_response_template.ecol_resp_parameters.where(approval_status: "U").update_all(approval_status: "A")
      @ecollect_response_template.ecol_resp_matrices.where(approval_status: "U").update_all(approval_status: "A")
      UnapprovedRecord.where(approvable_id:  @ecollect_response_template.id, approvable_type: "EcollectResponseTemplate").delete_all

      flash[:alert] = "Ecollect Response Template Approved successfully"
      redirect_to "/ecollect_response_templates/#{@ecollect_response_template.id}"
    else
      flash[:notice] = "Sorry you don't have Privilege to Approve the ECollect Response Template!"
      redirect_to "/"
    end
  end
  
	def show
    @ecollect_response_template = EcollectResponseTemplate.unscoped.find_by_id(params[:id])
  end

	private

	def ecollect_response_template_params
    params.require(:ecollect_response_template).permit(:client_code,:response_code,:created_by,:updated_by,:api_type,:step_name,:is_error_flag,
                                                  ecol_resp_parameters_attributes: [:id,:expression_to_evaluate, :response_template_id, :parameter_type, :key, :ecollect_response_key, :response_matrix_key, :created_by, :updated_by,:_destroy],
                                                  ecol_resp_matrices_attributes: [:id, :action, :key1,:key2,:key3,:key4,:key5,:key6,:key7,:key8,:key9, :key10,:response_template_id,:created_by,:updated_by,:_destroy])
  end

end