class EcollectEncryptDecryptsController < ApplicationController
	authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  # include EcollectResponseTemplateHelper

  def index
    # if params[:advanced_search].present?
    #   ecollect_request_templates = find_dp_esb_mappers(params).order("id DESC")
    # else
      ecollect_encrypt_decrypts = EcollectEncryptDecrypt.order("id desc")
    # end
    @ecollect_encrypt_decrypts = ecollect_encrypt_decrypts.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

	def new
		@ecollect_encrypt_decrypt = EcollectEncryptDecrypt.new
	end

	def create
		@ecollect_encrypt_decrypt = EcollectEncryptDecrypt.new(ecollect_encrypt_decrypt_params)
    if !@ecollect_encrypt_decrypt.valid?
      render "new"
    else
      @ecollect_encrypt_decrypt.created_by = current_user.id
      @ecollect_encrypt_decrypt.save!
      flash[:alert] = "ECollect Encrytpt Decrypt created successfully"
      redirect_to @ecollect_encrypt_decrypt
    end
	end

	def update
    @ecollect_encrypt_decrypt = EcollectEncryptDecrypt.unscoped.find_by_id(params[:id])
    @ecollect_encrypt_decrypt.attributes = params[:ecollect_encrypt_decrypt]
    if !@ecollect_encrypt_decrypt.valid?
      render "edit"
    else
    	@ecollect_encrypt_decrypt.request_template_id = params[:template_id]
      @ecollect_encrypt_decrypt.updated_by = current_user.id
      @ecollect_encrypt_decrypt.save!
      flash[:alert] = 'ECollect Encrytpt Decrypt modified successfully'
      redirect_to @ecollect_encrypt_decrypt
    end
    rescue ActiveRecord::StaleObjectError
      @ecollect_encrypt_decrypt.reload
      flash[:alert] = 'Someone edited the code the same time you did. Please re-apply your changes to the code.'
      render "edit"
  end

  def edit
    @ecollect_encrypt_decrypt = EcollectEncryptDecrypt.unscoped.find_by_id(params[:id])
  end

	def show
    @ecollect_encrypt_decrypt = EcollectEncryptDecrypt.unscoped.find_by_id(params[:id])
  end

	private

	def ecollect_encrypt_decrypt_params
    params.require(:ecollect_encrypt_decrypt).permit(:algorithm, :decrypt_response, :key, :parameter_type, :request_template_id, :secret_key, :created_by, :updated_by)
  end

end