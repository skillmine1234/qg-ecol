class EcolVaMemoTxnsController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json  
  include ApplicationHelper
  include Approval2::ControllerAdditions
  
  rescue_from 'Fault::ProcedureFault','OCIError' do |e|
   flash[:alert] = "#{e.message}"
   redirect_to unapproved_records_path(group_name: 'e-collect')
  end
  
  def new
    @ecol_va_memo_txn = EcolVaMemoTxn.new
  end

  def create
    @ecol_va_memo_txn = EcolVaMemoTxn.new(ecol_va_memo_txn_params)
    if !@ecol_va_memo_txn.valid?
      render "new"
    else
      @ecol_va_memo_txn.created_by = current_user.id
      @ecol_va_memo_txn.save!
      flash[:alert] = "Record successfully created and is pending for approval"
      redirect_to @ecol_va_memo_txn
    end
  end

  def show
    @ecol_va_memo_txn = EcolVaMemoTxn.unscoped.find_by_id(params[:id])
  end

  def index
    if request.get?
      @searcher = EcolVaMemoTxnSearcher.new(params.permit(:page, :approval_status))
    else
      @searcher = EcolVaMemoTxnSearcher.new(search_params)
    end
    @records = @searcher.paginate
  end

  def approve
    redirect_to unapproved_records_path(group_name: 'e-collect')
  end

  def destroy
    ecol_va_memo_txn = EcolVaMemoTxn.unscoped.find_by_id(params[:id])
    if ecol_va_memo_txn.approval_status == 'U' and (current_user == ecol_va_memo_txn.created_user or (can? :approve, ecol_va_memo_txn))
      ecol_va_memo_txn = ecol_va_memo_txn.destroy
      flash[:alert] = "Transaction has been deleted!"
      redirect_to ecol_va_memo_txns_path(:approval_status => 'U')
    else
      flash[:alert] = "You cannot delete this record!"
      redirect_to ecol_va_memo_txns_path(:approval_status => 'U')
    end
  end

  private
  
  def search_params
    params.require(:ecol_va_memo_txn_searcher).permit(:account_no, :txn_type, :from_txn_amount, :to_txn_amount)
  end

  def ecol_va_memo_txn_params
    params.require(:ecol_va_memo_txn).permit(:reference_no, :account_no, :txn_amount, :txn_type, :txn_desc, :customer_code, 
                                             :created_at, :updated_at, :created_by, :updated_by, :lock_version, :approved_id, :approved_version)
  end
end