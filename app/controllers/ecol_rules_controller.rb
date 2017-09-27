class EcolRulesController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  include Approval2::ControllerAdditions
  
  def new
    @ecol_rule = EcolRule.new
  end

  def create
    @ecol_rule = EcolRule.new(params[:ecol_rule])
    if !@ecol_rule.valid?
      render "new"
    else
      @ecol_rule.created_by = current_user.id
      @ecol_rule.save
      flash[:alert] = 'Rule successfully created and is pending for approval'
      redirect_to @ecol_rule
    end
  end
  
  def update
    @ecol_rule = EcolRule.unscoped.find_by_id(params[:id])
    @ecol_rule.attributes = params[:ecol_rule]
    if !@ecol_rule.valid?
      render "edit"
    else
      @ecol_rule.updated_by = current_user.id
      @ecol_rule.save
      flash[:alert] = 'Rule successfuly modified and is pending for approval'
      redirect_to @ecol_rule
    end
    rescue ActiveRecord::StaleObjectError
      @ecol_rule.reload
      flash[:alert] = 'Someone edited the rule the same time you did. Please re-apply your changes to the rule.'
      render "edit"
  end 
  
  def index
    ecol_rules = EcolRule.unscoped.where("approval_status=?",'U').order("id desc")
    @ecol_rules_count = ecol_rules.count
    @ecol_rules = ecol_rules.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def show
    @ecol_rule = EcolRule.unscoped.find_by_id(params[:id])
  end
  
  def audit_logs
    @ecol_rule = EcolRule.unscoped.find(params[:id]) rescue nil
    @audit = @ecol_rule.audits[params[:version_id].to_i] rescue nil
  end
  
  def error_msg
    flash[:alert] = "Rule is not yet configured"
    redirect_to :root
  end
  
  def approve
    redirect_to unapproved_records_path(group_name: 'e-collect')
  end
  
  def destroy
    ecol_rule = EcolRule.unscoped.find_by_id(params[:id])
    if ecol_rule.approval_status == 'U' and (current_user == ecol_rule.created_user or (can? :approve, ecol_rule))
      ecol_rule = ecol_rule.destroy
      flash[:alert] = "Ecollect Rule record has been deleted!"
      redirect_to ecol_rules_path(:approval_status => 'U')
    else
      flash[:alert] = "You cannot delete this record!"
      redirect_to ecol_rules_path(:approval_status => 'U')
    end
  end

  private

  def ecol_rule_params
    params.require(:ecol_rule).permit(:ifsc, :cod_acct_no, :stl_gl_inward, :lock_version,
                                      :approval_status, :approved_version, :approved_id, :neft_sender_ifsc,
                                      :customer_id, :return_account_no, :allow_return_by_rtgs)
  end
end
