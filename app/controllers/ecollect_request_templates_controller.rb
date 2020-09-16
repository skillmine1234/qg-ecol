class EcollectRequestTemplatesController < ApplicationController
	authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  # include EcollectRequestTemplateHelper

  def index
    # if params[:advanced_search].present?
    #   ecollect_request_templates = find_dp_esb_mappers(params).order("id DESC")
    # else
      ecollect_request_templates = EcollectRequestTemplate.order("id desc")
    # end
    @ecollect_request_templates = ecollect_request_templates.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

	def new
		@ecollect_request_template = EcollectRequestTemplate.new
		@ecollect_request_template.ecollect_request_parameters.build
    @ecollect_request_template.ecollect_encrypt_decrypts.build
		@ecollect_request_template.ecollect_hash_templates.build
    @ecollect_request_template.ecollect_hash_parameters.build

    @ecollect_request_templates = EcollectRequestTemplate.where(client_code: params[:customer_code],step_name: params[:step_name] == "Validate" ? "VAL" : "NOT")
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
      	flash[:alert] = "ECollect Request Template created successfully"
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
    if !@ecollect_request_template.valid?
      render "edit"
    else
      @ecollect_request_template.updated_by = current_user.id
      @ecollect_request_template.save!
      if @ecollect_request_template.is_hash_required == false && (@ecollect_request_template.ecollect_hash_templates.present? || @ecollect_request_template.ecollect_hash_parameters.present?)
        @ecollect_request_template.ecollect_hash_templates.delete_all
        @ecollect_request_template.ecollect_hash_parameters.delete_all
      end
      if @ecollect_request_template.is_encryption_required == false
        @ecollect_request_template.ecollect_encrypt_decrypts.delete_all if @ecollect_request_template.ecollect_encrypt_decrypts.present?
      end
      flash[:alert] = 'ECollect Request Template modified successfully'
      redirect_to @ecollect_request_template
    end
    rescue ActiveRecord::StaleObjectError
      @ecollect_request_template.reload
      flash[:alert] = 'Someone edited the code the same time you did. Please re-apply your changes to the code.'
      render "edit"
  end

  def edit
    @ecollect_request_template = EcollectRequestTemplate.unscoped.find_by_id(params[:id])
    @ecollect_request_template.ecollect_request_parameters.build if !@ecollect_request_template.ecollect_request_parameters.present?
    @ecollect_request_template.ecollect_encrypt_decrypts.build if !@ecollect_request_template.ecollect_encrypt_decrypts.present?
    @ecollect_request_template.ecollect_hash_templates.build if !@ecollect_request_template.ecollect_hash_templates.present?
    @ecollect_request_template.ecollect_hash_parameters.build if !@ecollect_request_template.ecollect_hash_parameters.present?
  end

	def show
    @ecollect_request_template = EcollectRequestTemplate.unscoped.find_by_id(params[:id])
  end

	private

	def ecollect_request_template_params
    params.require(:ecollect_request_template).permit(:client_code,:request,:request_type,:url,:is_encryption_required,:is_hash_required,:created_by,:updated_by,:api_type,:secret_key,:decrypt_response,:algorithm,:step_name,
                                              ecollect_encrypt_decrypts_attributes: [:id,:algorithm, :key, :parameter_type, :request_template_id, :secret_key, :created_by, :updated_by, :decrypt_response,:_destroy],
                                              ecollect_hash_templates_attributes: [:id,:checksum_type,:key,:parameter_type,:request,:request_template_id,:created_by,:updated_by,:_destroy],
                                              ecollect_hash_parameters_attributes: [:id, :format, :format_datatype,:request_template_id,:key,:parameter_type,:value,:value_type,:created_by,:updated_by,:custom_function, :_destroy],
                                              ecollect_request_parameters_attributes: [:id,:request_template_id, :format_datatype, :key, :parameter_type, :format, :value, :length, :created_by, :updated_by, :custom_function, :value_type,:_destroy])
  end

end