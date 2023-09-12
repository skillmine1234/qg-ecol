require 'will_paginate/array'

class EcolVacdIncomingRecordsController < ApplicationController
  authorize_resource
  before_action :authenticate_user!
  before_action :block_inactive_user!
  respond_to :json, :html
  include SuIncomingRecordsHelper

  def index
    @incoming_file = IncomingFile.find_by_file_name(params[:file_name]) rescue nil
    if request.get?
      # only 'safe/non-personal' parameters are allowed as search parameters in a query string
      @searcher = EcolVacdIncomingRecordSearcher.new(params.permit(:status, :file_name, :overrided_flag, :page))
    else
      # rest parameters are in post
      @searcher = EcolVacdIncomingRecordSearcher.new(search_params)
    end
    @records = @searcher.paginate
  end

  def show
    @ecol_record = EcolVacdIncomingRecord.find_by_id(params[:id])
  end

  def audit_logs
    @record = IncomingFileRecord.find(params[:id]) rescue nil
    @audit = @record.audits[params[:version_id].to_i] rescue nil
  end

  def incoming_file_summary
    @summary = EcolVacdIncomingFile.find_by_file_name(params[:file_name])
  end

  def search_params
    params.require(:ecol_vacd_incoming_record_searcher).permit(:page, :account_no, :txn_type, :file_name, :status, :overrided_flag)
  end
end