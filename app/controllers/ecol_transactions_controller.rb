require 'will_paginate/array'
class EcolTransactionsController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  include EcolTransactionsHelper
  
  def index
    ecol_transactions = EcolTransaction.order("id desc")
    if params[:advanced_search].present? || params[:summary].present?
      ecol_transactions = find_ecol_transactions(ecol_transactions,params).order("id desc")
    end
    @ecol_transactions_count = ecol_transactions.count(:id)
    @ecol_transactions = ecol_transactions.paginate(:per_page => 10, :page => params[:page]) rescue []
  end
  
  def show
    @ecol_transaction = EcolTransaction.find_by_id(params[:id])
  end
  
  def summary 
    ecol_transactions = EcolTransaction.order("id desc")
    @ecol_transaction_summary = EcolTransaction.group(:status, :pending_approval).count(:id)
    @ecol_transaction_statuses = EcolTransaction.group(:status).count(:id).keys
    @total_pending_records = EcolTransaction.where(:pending_approval => 'Y').count(:id)
    @total_records = EcolTransaction.count(:id)
    
    @ecol_notify_summary = EcolTransaction.where("ecol_transactions.notify_status IS NOT NULL").group(:notify_status, :pending_approval).count(:id)
    @ecol_notify_statuses = EcolTransaction.where("ecol_transactions.notify_status IS NOT NULL").group(:notify_status).count(:id).keys
  end

  def update_multiple
    if params[:ecol_transaction_ids]
      @ecol_transactions = EcolTransaction.find(params[:ecol_transaction_ids])
      result = check_transactions(@ecol_transactions,params)
      selected_records = result[:records]
      status = result[:status] 
      if selected_records.empty?
        @ecol_transactions = update_transactions(@ecol_transactions,params)
        flash[:notice] = "Updated transactions!"
      else
        flash[:notice] = "Please select only " + status + " transactions"
      end
    else
      flash[:notice] = "You haven't selected any transaction records!"
    end    
    redirect_to :back
  end

  def approve_transaction
    @ecol_transaction = EcolTransaction.find(params[:id])
    if @ecol_transaction.pending_approval == 'Y'
      if @ecol_transaction.update_attributes(:pending_approval => "N")
        flash[:notice] = "Ecollect Transaction is sucessfully approved"
      else
        flash[:notice] = @ecol_transaction.errors.full_messages
      end
    else
      flash[:notice] = "Transaction is already approved"
    end   
    redirect_to :back
  end

  def ecol_audit_logs
    @ecol_transaction = EcolTransaction.find(params[:id])
    ecol_values = find_logs(params, @ecol_transaction)
    @ecol_values_count = ecol_values.count(:id)
    @ecol_values = ecol_values.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def update
    @ecol_transaction = EcolTransaction.find(params[:id])
    if params[:state] == 'SETTLEMENT'
      @ecol_transaction.settle_status = 'PENDING ' + params[:state]
    elsif params[:state] == 'NOTIFICATION'
      @ecol_transaction.notify_status = 'PENDING ' + params[:state]
    else
      @ecol_transaction.status = 'PENDING ' + params[:state]
      @ecol_transaction.validation_status = 'PENDING ' + params[:state] if params[:state] == 'VALIDATION'
    end
    @ecol_transaction.pending_approval = 'N'
    if !@ecol_transaction.save
      flash[:notice] = @ecol_transaction.errors.full_messages
    else
      flash[:notice] = "Ecollect Transaction is sucessfully updated"
    end
    redirect_to :back
  end
  
  def override_transaction
    ecol_transaction = EcolTransaction.find(params[:id])
    ActiveRecord::Base.transaction do
      if params[:status].blank?
        flash[:alert] = "Please choose a status!"
      else
        ecol_transaction.override(params[:status], @current_user.id, params[:remarks])
        flash[:alert] = "Transaction status has been overriden successfully!"
      end
    end
  rescue ::Fault::ProcedureFault, OCIError => e
   flash[:alert] = "#{e.message}"    
  ensure
   redirect_to ecol_transaction
  end

  private

  def ecol_transaction_params
    params.require(:ecol_transaction).permit(:status, :transfer_type, :transfer_unique_no, :transfer_status, 
    :transfer_timestamp, :transfer_ccy, :transfer_amt, :rmtr_ref, :rmtr_full_name, :rmtr_address, :rmtr_account_type, :rmtr_account_no,
    :rmtr_account_ifsc, :bene_full_name, :bene_account_type, :bene_account_no, :bene_account_ifsc, :rmtr_to_bene_note, :received_at, :tokenized_at,
    :tokenzation_status, :customer_code, :customer_subcode, :remitter_code, :validate_attempt_at, :validation_status,
    :credited_at, :credit_status, :credit_ref, :credit_attempt_no, :rmtr_email_notify_ref, :rmtr_sms_notify_ref,
    :settled_at, :settle_status, :settle_ref, :settle_attempt_no, :fault_at, :fault_code, :fault_reason, :created_at,
    :updated_at, :ecol_remitter_id, :pending_approval)
  end
  
end
