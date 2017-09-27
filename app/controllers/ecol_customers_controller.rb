class EcolCustomersController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  include EcolCustomersHelper
  include Approval2::ControllerAdditions
  
  def new
    @ecol_customer = EcolCustomer.new
  end
  
  def create
    @ecol_customer = EcolCustomer.new(params[:ecol_customer])
    if !@ecol_customer.valid?
      render "new"
    else
      @ecol_customer.created_by = current_user.id
      @ecol_customer.save!
      flash[:alert] = 'Customer successfully created and is pending for approval'
      redirect_to @ecol_customer
    end
  end
  
  def update
    @ecol_customer = EcolCustomer.unscoped.find_by_id(params[:id])
    @ecol_customer.attributes = params[:ecol_customer]
    if !@ecol_customer.valid?
      render "edit"
    else
      @ecol_customer.updated_by = current_user.id
      @ecol_customer.save!
      flash[:alert] = 'Customer successfully modified and is pending for approval'
      redirect_to @ecol_customer
    end
    rescue ActiveRecord::StaleObjectError
      @ecol_customer.reload
      flash[:alert] = 'Someone edited the customer the same time you did. Please re-apply your changes to the customer.'
      render "edit"
  end
  
  def show
    @ecol_customer = EcolCustomer.unscoped.find_by_id(params[:id])
  end

  def index
    if params[:advanced_search].present?
      ecol_customers = find_ecol_customers(params).order("id desc")
    else
      ecol_customers = (params[:approval_status].present? and params[:approval_status] == 'U') ? EcolCustomer.unscoped.where("approval_status =?",'U').order("id desc") : EcolCustomer.order("id desc")
    end
    @ecol_customers_count = ecol_customers.count
    @ecol_customers = ecol_customers.paginate(:per_page => 10, :page => params[:page]) rescue []
  end
  
  def audit_logs
    @ecol_customer = EcolCustomer.unscoped.find(params[:id]) rescue nil
    @audit = @ecol_customer.audits[params[:version_id].to_i] rescue nil
  end

  def approve
    redirect_to unapproved_records_path(group_name: 'e-collect')
  end
  
  def destroy
    ecol_customer = EcolCustomer.unscoped.find_by_id(params[:id])
    if ecol_customer.approval_status == 'U' and (current_user == ecol_customer.created_user or (can? :approve, ecol_customer))
      ecol_customer = ecol_customer.destroy
      flash[:alert] = "Ecollect Customer record has been deleted!"
      redirect_to ecol_customers_path(:approval_status => 'U')
    else
      flash[:alert] = "You cannot delete this record!"
      redirect_to ecol_customers_path(:approval_status => 'U')
    end
  end

  private

  def ecol_customer_params
    params.require(:ecol_customer).permit(:code, :name, :is_enabled, :val_method, :token_1_type, :token_1_length, :val_token_1, :token_2_type,
  :token_2_length, :val_token_2, :token_3_type, :token_3_length, :val_token_3, :val_txn_date, :val_txn_amt, :val_ben_name,
  :val_rem_acct, :return_if_val_reject, :file_upld_mthd, :credit_acct_val_pass, :credit_acct_val_fail, :nrtv_sufx_1, :nrtv_sufx_2, :nrtv_sufx_3, :rmtr_alert_on,
  :rmtr_pass_txt, :rmtr_return_txt, :created_by, :updated_by, :lock_version, :auto_credit, :auto_return, :approved_id, :approved_version, :val_rmtr_name, 
  :val_last_token_length, :token_1_starts_with, :token_1_contains, :token_1_ends_with, :token_2_starts_with, :token_2_contains, 
  :token_2_ends_with, :token_3_starts_with, :token_3_contains, :token_3_ends_with, :customer_id, :cust_alert_on,
  :pool_acct_no, :app_code, :identity_user_id, :should_prevalidate, {allowed_operations: []})
  end
end
