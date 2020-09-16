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
      ecollect_response_templates = EcollectResponseTemplate.order("id desc")
    # end
    @ecollect_response_templates = ecollect_response_templates.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

	def new
    @ecollect_response_template = EcollectResponseTemplate.new
    @ecollect_response_template.ecol_resp_parameters.build
    @ecollect_response_template.ecol_resp_matrices.build

    @ecollect_response_templates = EcollectResponseTemplate.where(client_code: params[:customer_code],step_name: params[:step_name] == "Validate" ? "VAL" : "NOT")
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
        flash[:alert] = "ECollect Response Template created successfully"
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
    if !@ecollect_response_template.valid?
      render "edit"
    else
      @ecollect_response_template.updated_by = current_user.id
      @ecollect_response_template.save!
      flash[:alert] = 'ECollect Response Template modified successfully'
      redirect_to @ecollect_response_template
    end
    rescue ActiveRecord::StaleObjectError
      @ecollect_response_template.reload
      flash[:alert] = 'Someone edited the code the same time you did. Please re-apply your changes to the code.'
      render "edit"
  end

  def edit
    @ecollect_response_template = EcollectResponseTemplate.unscoped.find_by_id(params[:id])
    @ecollect_response_template.ecol_resp_parameters.build if !@ecollect_response_template.ecol_resp_parameters.present?
    @ecollect_response_template.ecol_resp_matrices.build if !@ecollect_response_template.ecol_resp_matrices.present?
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