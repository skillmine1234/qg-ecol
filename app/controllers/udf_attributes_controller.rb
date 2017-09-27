class UdfAttributesController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  include Approval2::ControllerAdditions
  
  def new
    @udf_attribute = UdfAttribute.new
  end

  def create
    @udf_attribute = UdfAttribute.new(params[:udf_attribute])
    if !@udf_attribute.valid?
      render "new"
    else
      @udf_attribute.created_by = current_user.id
      @udf_attribute.save
      flash[:alert] = 'Udf successfully created and is pending for approval'
      redirect_to @udf_attribute
    end
  end

  def update
    @udf_attribute = UdfAttribute.unscoped.find_by_id(params[:id])
    @udf_attribute.attributes = params[:udf_attribute]
    if !@udf_attribute.valid?
      render "edit"
    else
      @udf_attribute.updated_by = current_user.id
      @udf_attribute.save
      flash[:alert] = 'Udf successfully modified and is pending for approval'
      redirect_to @udf_attribute
    end
    rescue ActiveRecord::StaleObjectError
      @udf_attribute.reload
      flash[:alert] = 'Someone edited the udf the same time you did. Please re-apply your changes to the udf.'
      render "edit"
  end

  def show
    @udf_attribute = UdfAttribute.unscoped.find_by_id(params[:id])
  end

  def index
    udf_attributes = (params[:approval_status].present? and params[:approval_status] == 'U') ? UdfAttribute.unscoped.where("approval_status =?",'U').order("id desc") : UdfAttribute.order("id desc")
    @udf_attributes_count = udf_attributes.count
    @udf_attributes = udf_attributes.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def audit_logs
    @udf_attribute = UdfAttribute.unscoped.find(params[:id]) rescue nil
    @audit = @udf_attribute.audits[params[:version_id].to_i] rescue nil
  end

  def approve
    redirect_to unapproved_records_path(group_name: 'e-collect')
  end
  
  def destroy
    udf_attribute = UdfAttribute.unscoped.find_by_id(params[:id])
    if udf_attribute.approval_status == 'U' and (current_user == udf_attribute.created_user or (can? :approve, udf_attribute))
      udf_attribute = udf_attribute.destroy
      flash[:alert] = "UdfAttribute record has been deleted!"
      redirect_to udf_attributes_path(:approval_status => 'U')
    else
      flash[:alert] = "You cannot delete this record!"
      redirect_to udf_attributes_path(:approval_status => 'U')
    end
  end

private

  def udf_attribute_params
    params.require(:udf_attribute).permit(:class_name, :attribute_name, :label_text, :is_enabled, :is_mandatory, 
    :control_type, :data_type, :constraints, :select_options,:length, :max_length, :min_length, :min_value, 
    :max_value, :lock_version, :approved_version, :approved_id)
  end
end
