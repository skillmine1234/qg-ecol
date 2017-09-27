class QgEcolTodaysImpsTxnsController < ApplicationController

  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  before_filter :block_screens  
  respond_to :json
  include ApplicationHelper
  include QgEcolTodaysImpsTxnsHelper

  def new
    @qg_ecol_todays_imps_txn = QgEcolTodaysImpsTxn.new
  end

  def create
    @qg_ecol_todays_imps_txn = QgEcolTodaysImpsTxn.new(params[:qg_ecol_todays_imps_txn])
    if !@qg_ecol_todays_imps_txn.valid?
      render "new"
    else
      @qg_ecol_todays_imps_txn.save!
      flash[:alert] = 'IMPS Transaction successfully created'
      redirect_to qg_ecol_todays_imps_txns_path
    end
  end

  def edit
    @qg_ecol_todays_imps_txn = QgEcolTodaysImpsTxn.find(params[:id])
  end

  def update
    @qg_ecol_todays_imps_txn = QgEcolTodaysImpsTxn.find(params[:id])
    @qg_ecol_todays_imps_txn.attributes = params[:qg_ecol_todays_imps_txn]
    if !@qg_ecol_todays_imps_txn.valid?
      render "edit"
    else
      @qg_ecol_todays_imps_txn.save!
      flash[:alert] = 'IMPS Transaction successfully modified'
      redirect_to qg_ecol_todays_imps_txns_path
    end
  end

  def index
    qg_ecol_todays_imps_txns = QgEcolTodaysImpsTxn.order("id desc")
    @qg_ecol_todays_imps_txns_count = qg_ecol_todays_imps_txns.count
    @qg_ecol_todays_imps_txns = qg_ecol_todays_imps_txns.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def show
    @qg_ecol_todays_imps_txn = QgEcolTodaysImpsTxn.find(params[:id])
  end

  def destroy
    qg_ecol_todays_imps_txn = QgEcolTodaysImpsTxn.find(params[:id])
    qg_ecol_todays_imps_txn.destroy
    flash[:alert] = "IMPS Transaction record has been deleted!"
    redirect_to qg_ecol_todays_imps_txns_path
  end

  private
    def qg_ecol_todays_imps_txn_params
      params.require(:qg_ecol_todays_imps_txn).permit(:rrn, :transfer_type, :transfer_status, :transfer_unique_no, :rmtr_ref, :bene_account_ifsc, :bene_account_no, :bene_account_type, 
                                                      :rmtr_account_ifsc, :rmtr_account_no, :rmtr_account_type, :transfer_amt, :transfer_ccy, :transfer_date, :pool_account_no, :rmtr_to_bene_note, 
                                                      :rmtr_full_name, :rmtr_address, :bene_full_name, :status, :error_code)
    end
end

