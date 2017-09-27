class QgEcolTodaysNeftTxnsController < ApplicationController

  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  before_filter :block_screens  
  respond_to :json
  include ApplicationHelper
  include QgEcolTodaysNeftTxnsHelper

  def new
    @qg_ecol_todays_neft_txn = QgEcolTodaysNeftTxn.new
  end

  def create
    @qg_ecol_todays_neft_txn = QgEcolTodaysNeftTxn.new(params[:qg_ecol_todays_neft_txn])
    if !@qg_ecol_todays_neft_txn.valid?
      render "new"
    else
      @qg_ecol_todays_neft_txn.save!
      flash[:alert] = 'NEFT Transaction successfully created'
      redirect_to qg_ecol_todays_neft_txns_path
    end
  end

  def edit
    @qg_ecol_todays_neft_txn = QgEcolTodaysNeftTxn.find(params[:id])
  end

  def update
    @qg_ecol_todays_neft_txn = QgEcolTodaysNeftTxn.find(params[:id])
    @qg_ecol_todays_neft_txn.attributes = params[:qg_ecol_todays_neft_txn]
    if !@qg_ecol_todays_neft_txn.valid?
      render "edit"
    else
      @qg_ecol_todays_neft_txn.save!
      flash[:alert] = 'NEFT Transaction successfully modified'
      redirect_to qg_ecol_todays_neft_txns_path
    end
  end

  def index
    qg_ecol_todays_neft_txns = QgEcolTodaysNeftTxn.order("id desc")
    @qg_ecol_todays_neft_txns_count = qg_ecol_todays_neft_txns.count
    @qg_ecol_todays_neft_txns = qg_ecol_todays_neft_txns.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def show
    @qg_ecol_todays_neft_txn = QgEcolTodaysNeftTxn.find(params[:id])
  end

  def destroy
    qg_ecol_todays_neft_txn = QgEcolTodaysNeftTxn.find(params[:id])
    qg_ecol_todays_neft_txn.destroy
    flash[:alert] = "NEFT Transaction record has been deleted!"
    redirect_to qg_ecol_todays_neft_txns_path
  end

  private

    def qg_ecol_todays_neft_txn_params
      params.require(:qg_ecol_todays_neft_txn).permit(:ref_txn_no, :transfer_type, :transfer_status, :transfer_unique_no, :rmtr_ref, :bene_account_ifsc, :bene_account_no, :bene_account_type, :rmtr_account_ifsc, :rmtr_account_no, :rmtr_account_type, :transfer_amt, :transfer_ccy, :transfer_date, :rmtr_to_bene_note, :rmtr_full_name, :rmtr_address, :bene_full_name)
    end
end

