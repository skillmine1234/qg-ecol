Rails.application.routes.draw do  
  
  resources :ecol_customers do
     collection do
      patch :index
     end
  end

  
  resources :ecol_remitters do 
    collection do
      patch :index
    end 
  end

  resources :ecol_transactions do
    collection do
      post  'update_multiple'
      patch :index
    end
    member do
      post :override_transaction_add_to_approval 
      post :override_transaction
      post :pending_validation
      post :approve_ecol_trans
    end
  end
  resources :udf_attributes
  resources :ecol_rules
  resources :ecol_fetch_statistics
  resources :ecol_app_udtables
  resources :ecol_summaries, only: [:index]

  resources :ecol_apps do
    collection do
      patch :index
    end
  end

  resources :ecollect_request_templates do
    member do
      post :request_template_audit_logs
      post :custom_approval_of_record
    end
  end
  resources :ecollect_response_templates do
    member do
      post :response_template_audit_logs
      post :custom_approval_of_record
    end
  end
  
  get '/ecol_rule/:id/audit_logs' => 'ecol_rules#audit_logs'
  get '/ecol_customer/:id/audit_logs' => 'ecol_customers#audit_logs'
  get '/ecol_remitter/:id/audit_logs' => 'ecol_remitters#audit_logs'
  post '/ecol_error_msg' => "ecol_rules#error_msg"
  post '/ecol_customer/:id/approve' => "ecol_customers#approve"
  post '/ecol_remitter/:id/approve' => "ecol_remitters#approve"
  post '/ecol_rule/:id/approve' => "ecol_rules#approve"
  post '/ecol_transactions/:id/ecol_audit_logs/:step_name' => 'ecol_transactions#ecol_audit_logs'
  post '/ecol_transactions/:id/approve' => "ecol_transactions#approve_transaction"
  post 'ecol_apps/:app_code/ecol_app_udtables' => 'ecol_apps#ecol_app_udtables', as: :udtables
  post '/ecol_app_udtables/udfs/:app_code' => 'ecol_app_udtables#udfs'
  post '/ecol_app_udtables/:id/audit_logs' => 'ecol_app_udtables#audit_logs'
  post '/ecol_app_udtables/:id/approve' => "ecol_app_udtables#approve"
  get '/ecol_apps/:id/audit_logs' => 'ecol_apps#audit_logs'
  post '/ecol_apps/:id/approve' => "ecol_apps#approve"
  post '/udf_attribute/:id/audit_logs' => 'udf_attributes#audit_logs'
  post '/udf_attribute/:id/approve' => "udf_attributes#approve"
  
  resources :ecol_vacd_incoming_records do
    collection do
      patch :index
    end
  end
  
  post 'ecol_vacd_incoming_file_summary' => 'ecol_vacd_incoming_records#incoming_file_summary'
  post '/ecol_vacd_incoming_records/:id/audit_logs' => 'ecol_vacd_incoming_records#audit_logs'
  
  resources :ecol_incoming_records do
    collection do
      post :index
    end
    member do
      post :audit_logs
    end
  end
  post 'ecol_incoming_file_summary' => 'ecol_incoming_records#incoming_file_summary'
end
