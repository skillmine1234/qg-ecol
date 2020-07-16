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
	end

	def create
		@ecollect_request_template = EcollectRequestTemplate.new(ecollect_request_template_params)
    if !@ecollect_request_template.valid?
      render "new"
    else
      @ecollect_request_template.created_by = current_user.id
      @ecollect_request_template.save!
      flash[:alert] = "ECollect Request Template created successfully"
      redirect_to @ecollect_request_template
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
  end

	def show
    @ecollect_request_template = EcollectRequestTemplate.unscoped.find_by_id(params[:id])
  end

	private

	def ecollect_request_template_params
    params.require(:ecollect_request_template).permit(:client_code,:request,:request_type,:url,
                                        :is_encryption_required,:is_hash_required,:created_by,:updated_by,:api_type,:secret_key,:decrypt_response,:algorithm)
  end

end