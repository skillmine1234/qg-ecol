class EcolVaEarmarksController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json

  def index

    if params[:ecol_va_account_id].present?
      # nested resource

      va_account = get_parent_resources

      if request.get?
        @searcher = EcolVaEarmark.new(nested_search_params)
      else
        @searcher = EcolVaEarmark.new(search_params)
      end

      @records = EcolVaEarmarkDecorator.decorate_collection(@searcher.paginate)
      @va_account = va_account.decorate

      render 'panel'
    else
      # direct
      if request.get?
        @searcher = EcolVaEarmark.new(params.permit(:page, :approval_status))
      else
        @searcher = EcolVaEarmark.new(search_params)
      end

      @records = EcolVaEarmarkDecorator.decorate_collection(@searcher.paginate)
    end
  end
  
  def show
    # the show page for the earmark shows all transactions for the earmark
    @va_earmark = EcolVaEarmark.find(params[:id])
    
    redirect_to ecol_va_account_ecol_va_earmark_ecol_va_txns_path(@va_earmark.ecol_va_account.id, @va_earmark.id)
  end

  private
  
  def nested_search_params
    params.require(:customer_code)
    params.require(:account_no)
    params.permit(:customer_code, :account_no, :hold_no, :page, :approval_status)
  end
  
  def get_parent_resources
    va_account =  nil
    
    if params[:ecol_va_account_id].present?
      va_account = EcolVaAccount.find(params[:ecol_va_account_id])
      params.merge!(account_no: va_account.account_no)
      params.merge!(customer_code: va_account.customer_code)

    end

    return va_account
  end  

  def search_params
    params.require(:ecol_va_earmark).permit(:page, :approval_status, :customer_code, :account_no, :hold_no, :from_created_at, :to_created_at, :from_updated_at, :to_updated_at, :from_hold_amount, :to_hold_amount)
  end

end
