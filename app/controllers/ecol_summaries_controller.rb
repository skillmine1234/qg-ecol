class EcolSummariesController < ApplicationController
  authorize_resource
  before_action :authenticate_user!
  before_action :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  
  def index
    ecol_transactions = EcolTransaction.order("id desc")
    @ecol_transaction_summary = EcolTransaction.group(:status, :pending_approval).count(:id)
    @ecol_transaction_statuses = EcolTransaction.group(:status).count(:id).keys
    @total_pending_records = EcolTransaction.where(:pending_approval => 'Y').count(:id)
    @total_records = EcolTransaction.count(:id)
    
    @ecol_notify_summary = EcolTransaction.where("ecol_transactions.notify_status IS NOT NULL").group(:notify_status, :pending_approval).count(:id)
    @ecol_notify_statuses = EcolTransaction.where("ecol_transactions.notify_status IS NOT NULL").group(:notify_status).count(:id).keys
  end
end