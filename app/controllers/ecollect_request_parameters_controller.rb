class EcollectRequestParametersController < ApplicationController
	authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper


  def index
    # if params[:advanced_search].present?
    #   ecollect_hash_templates = find_dp_esb_mappers(params).order("id DESC")
    # else
     ecollect_request_parameters = EcollectRequestParameter.order("id desc")
    # end
    @ecollect_request_parameters = ecollect_request_parameters.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

	def new
		@ecollect_request_parameter = EcollectRequestParameter.new
	end

	def create
		@ecollect_request_parameter = EcollectRequestParameter.new(ecollect_request_parameter_params)
    if !@ecollect_request_parameter.valid?
      render "new"
    else
      @ecollect_request_parameter.created_by = current_user.id
      @ecollect_request_parameter.save!
      flash[:alert] = "ECollect Request Parameter created successfully"
      redirect_to @ecollect_request_parameter
    end
	end


	def update
    @ecollect_request_parameter = EcollectRequestParameter.unscoped.find_by_id(params[:id])
    @ecollect_request_parameter.attributes = params[:ecollect_request_parameter]
    if !@ecollect_request_parameter.valid?
      render "edit"
    else
      @ecollect_request_parameter.updated_by = current_user.id
      @ecollect_request_parameter.save!
      flash[:alert] = 'ECollect Request Parameter modified successfully'
      redirect_to @ecollect_request_parameter
    end
    rescue ActiveRecord::StaleObjectError
      @ecollect_request_parameter.reload
      flash[:alert] = 'Someone edited the code the same time you did. Please re-apply your changes to the code.'
      render "edit"
  end

	def edit
    @ecollect_request_parameter = EcollectRequestParameter.unscoped.find_by_id(params[:id])
  end

	def show
    @ecollect_request_parameter = EcollectRequestParameter.unscoped.find_by_id(params[:id])
  end


	private

	def ecollect_request_parameter_params
    params.require(:ecollect_request_parameter).permit(:request_template_id, :format_datatype, :key, :parameter_type, :format, :value, :length, :created_by, :updated_by, :custom_function, :value_type)
                               
  end


end