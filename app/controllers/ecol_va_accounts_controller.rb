class EcolVaAccountsController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json

  def show
    @va_account = EcolVaAccount.find(params[:id])
  end
end