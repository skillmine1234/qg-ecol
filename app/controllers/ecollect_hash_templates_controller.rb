class EcollectHashTemplatesController < ApplicationController
	authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper


  def index
    # if params[:advanced_search].present?
    #   ecollect_hash_templates = find_dp_esb_mappers(params).order("id DESC")
    # else
     ecollect_hash_templates = EcollectHashTemplate.order("id desc")
    # end
    @ecollect_hash_templates = ecollect_hash_templates.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

	def new
		@ecollect_hash_template = EcollectHashTemplate.new
	end

	def create
		@ecollect_hash_template = EcollectHashTemplate.new(ecollect_hash_template_params)
    if !@ecollect_hash_template.valid?
      render "new"
    else
      @ecollect_hash_template.created_by = current_user.id
      @ecollect_hash_template.save!
      flash[:alert] = "ECollect Hash created successfully"
      redirect_to @ecollect_hash_template
    end
	end

	def update
    @ecollect_hash_template = EcollectHashTemplate.unscoped.find_by_id(params[:id])
    @ecollect_hash_template.attributes = params[:ecollect_hash_template]
    if !@ecollect_hash_template.valid?
      render "edit"
    else
      @ecollect_hash_template.updated_by = current_user.id
      @ecollect_hash_template.save!
      flash[:alert] = 'ECollect Hash modified successfully'
      redirect_to @ecollect_hash_template
    end
    rescue ActiveRecord::StaleObjectError
      @ecollect_hash_template.reload
      flash[:alert] = 'Someone edited the code the same time you did. Please re-apply your changes to the code.'
      render "edit"
  end

	def edit
    @ecollect_hash_template = EcollectHashTemplate.unscoped.find_by_id(params[:id])
  end

	def show
    @ecollect_hash_template = EcollectHashTemplate.unscoped.find_by_id(params[:id])
  end


	private

	def ecollect_hash_template_params
    params.require(:ecollect_hash_template).permit(:checksum_type,:key,:parameter_type,:request,
                                        :request_template_id,:created_by,:updated_by,
                                        ecollect_hash_parameters_attributes: [:id, :format, :format_datatype,:hash_template_id,:key,:parameter_type,:value,:value_type,:created_by,:updated_by,:custom_function, :_destroy])
  end


end