Rails.application.routes.draw do
  resources :qg_ecol_todays_rtgs_txns
  resources :qg_ecol_todays_neft_txns
  resources :qg_ecol_todays_imps_txns
  resources :qg_ecol_todays_upi_txns
  
  resources :ecol_customers
  resources :ecol_remitters
  resources :ecol_transactions do
    collection do
      put  'update_multiple'
    end
    member do
      put :override_transaction_add_to_approval 
      put :override_transaction
      put :pending_validation
      put :approve_ecol_trans
    end
  end
  resources :udf_attributes
  resources :ecol_rules
  resources :ecol_fetch_statistics
  resources :ecol_app_udtables
  resources :ecol_summaries, only: [:index]

  resources :ecol_apps do
    collection do
      put :index
    end
  end

  resources :ecollect_request_templates
  resources :ecollect_hash_templates
  resources :ecollect_response_templates
  resources :ecollect_request_parameters
  
  get '/ecol_rule/:id/audit_logs' => 'ecol_rules#audit_logs'
  get '/ecol_customer/:id/audit_logs' => 'ecol_customers#audit_logs'
  get '/ecol_remitter/:id/audit_logs' => 'ecol_remitters#audit_logs'
  get '/ecol_error_msg' => "ecol_rules#error_msg"
  put '/ecol_customer/:id/approve' => "ecol_customers#approve"
  put '/ecol_remitter/:id/approve' => "ecol_remitters#approve"
  put '/ecol_rule/:id/approve' => "ecol_rules#approve"
  get '/ecol_transactions/:id/ecol_audit_logs/:step_name' => 'ecol_transactions#ecol_audit_logs'
  put '/ecol_transactions/:id/approve' => "ecol_transactions#approve_transaction"
  get 'ecol_apps/:app_code/ecol_app_udtables' => 'ecol_apps#ecol_app_udtables', as: :udtables
  get '/ecol_app_udtables/udfs/:app_code' => 'ecol_app_udtables#udfs'
  get '/ecol_app_udtables/:id/audit_logs' => 'ecol_app_udtables#audit_logs'
  put '/ecol_app_udtables/:id/approve' => "ecol_app_udtables#approve"
  get '/ecol_apps/:id/audit_logs' => 'ecol_apps#audit_logs'
  put '/ecol_apps/:id/approve' => "ecol_apps#approve"
  get '/udf_attribute/:id/audit_logs' => 'udf_attributes#audit_logs'
  put '/udf_attribute/:id/approve' => "udf_attributes#approve"
  
  operation_routes_for 'ecol_va_transfers'

  resources :ecol_va_txns, :ecol_va_earmarks, :ecol_va_transfers do
    collection do
      put :index
    end
  end
  
  resources :ecol_va_earmarks do
    collection do
      put :index
    end
  end

  
  resources :ecol_va_accounts do
    member do
      get :show
      get :acct_txns
    end
    resources :ecol_va_txns do
      collection do
        put :index
      end
    end
    resources :ecol_va_earmarks do
      collection do
        put :index
      end
      resources :ecol_va_txns do
        collection do
          put :index
        end        
      end
    end
  end
  
  resources :ecol_vacd_incoming_records do
    collection do
      put :index
    end
  end
  
  resources :ecol_va_memo_txns do
    collection do
      put :index
    end
    member do
      put :approve
    end
  end
  
  get 'ecol_vacd_incoming_file_summary' => 'ecol_vacd_incoming_records#incoming_file_summary'
  get '/ecol_vacd_incoming_records/:id/audit_logs' => 'ecol_vacd_incoming_records#audit_logs'
  
  resources :ecol_incoming_records do
    collection do
      put :index
    end
    member do
      get :audit_logs
    end
  end
  get 'ecol_incoming_file_summary' => 'ecol_incoming_records#incoming_file_summary'
end
