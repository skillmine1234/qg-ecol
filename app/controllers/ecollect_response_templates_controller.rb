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
	end

	def create
		@ecollect_response_template = EcollectResponseTemplate.new(ecollect_response_template_params)
    if !@ecollect_response_template.valid?
      render "new"
    else
      @ecollect_response_template.created_by = current_user.id
      @ecollect_response_template.save!
      flash[:alert] = "ECollect Response Template created successfully"
      redirect_to @ecollect_response_template
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
  end

	def show
    @ecollect_response_template = EcollectResponseTemplate.unscoped.find_by_id(params[:id])
  end

	private

	def ecollect_response_template_params
    params.require(:ecollect_response_template).permit(:client_code,:response_code,:created_by,:updated_by,:api_type,:request_template_id)
  end

end