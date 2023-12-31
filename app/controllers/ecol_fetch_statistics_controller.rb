class EcolFetchStatisticsController < ApplicationController
  authorize_resource
  before_action :authenticate_user!
  before_action :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  
  def show
    @ecol_fetch_statistic = EcolFetchStatistic.find_by_id(params[:id])
  end  
end
