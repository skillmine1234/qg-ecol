class EcolVaTxnsController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json

  def index

    if params[:ecol_va_account_id].present? || params[:ecol_va_earmarks_id].present?
      # nested resource
      
      @va_account, @va_earmark = get_parent_resources
      
      if request.get?
        @searcher = EcolVaTxn.new(nested_search_params)
      else
        @searcher = EcolVaTxn.new(search_params)
      end

      @records = EcolVaTxnDecorator.decorate_collection(@searcher.paginate)

      @va_account = @va_account.decorate
      @va_earmark = @va_earmark.decorate unless @va_earmark.nil?

      render 'panel'
    else
      # direct
      if request.get?
        @searcher = EcolVaTxn.new(params.permit(:page, :approval_status))
      else
        @searcher = EcolVaTxn.new(search_params)
      end
      
      @records = EcolVaTxnDecorator.decorate_collection(@searcher.paginate)    
    end
  end
  
  def show
    @records = [EcolVaTxn.find(params[:id]).decorate]
    @va_account = @records.first.ecol_va_account
    render 'panel'
  end

  
  private
  
  def get_parent_resources
    va_account = va_earmark = nil
    
    if params[:ecol_va_account_id].present?
      va_account = EcolVaAccount.find(params[:ecol_va_account_id])
      params.merge!(account_no: va_account.account_no)
      params.merge!(customer_code: va_account.customer_code)

      if params[:ecol_va_earmark_id].present?
        va_earmark = EcolVaEarmark.find(params[:ecol_va_earmark_id])
        if va_earmark.is_of_account?(va_account)
          params.merge!(hold_no: va_earmark.hold_no)
        end
      end
    end

    return va_account, va_earmark
  end
  
  def nested_search_params
    params.require(:account_no)
    params.require(:customer_code)
    params.permit(:account_no, :customer_code, :hold_no, :page, :approval_status)
  end
  
  def search_params
    params.require(:ecol_va_txn).permit(:page, :approval_status, :account_no, :hold_no, :from_txn_timestamp, :to_txn_timestamp, :from_txn_amount, :to_txn_amount)
  end
  
end