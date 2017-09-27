require 'spec_helper'

describe EcolTransactionsController do
  include HelperMethods
  
  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
    
    mock_ldap
  end
  
  describe "GET index" do
    it "assigns all ecol_transactions as @ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction)
      get :index
      assigns(:ecol_transactions).should eq([ecol_transaction])
    end
  end
  
  describe "GET show" do
    it "assigns the requested ecol_transaction as @ecol_transaction" do
      ecol_transaction = Factory(:ecol_transaction)
      get :show, {:id => ecol_transaction.id}
      assigns(:ecol_transaction).should eq(ecol_transaction)
    end
  end
  
  describe "PUT update_multiple" do
    it "updates the requested credit ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'PENDING CREDIT', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      put :update_multiple, {:ecol_transaction_ids => [ecol_transaction.id], :ecol_transaction => params, :status => 'PENDING CREDIT', :approval => 'Y'}
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.pending_approval.should == "N"
    end

    it "updates the requested return ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'PENDING RETURN', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      params[:pending_approval] = "N"
      put :update_multiple, {:ecol_transaction_ids => [ecol_transaction.id], :ecol_transaction => params, :status => 'PENDING RETURN', :approval => 'Y'}
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.pending_approval.should == "N"
    end

    it "updates the requested return ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'RETURN FAILED', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      params[:pending_approval] = "N"
      put :update_multiple, {:ecol_transaction_ids => [ecol_transaction.id], :ecol_transaction => params, :status => 'RETURN FAILED', :approval => 'N'}
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.status.should == "PENDING RETURN"
      ecol_transaction.pending_approval.should == "N"
    end

    it "updates the requested credit ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'CREDIT FAILED', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      put :update_multiple, {:ecol_transaction_ids => [ecol_transaction.id], :ecol_transaction => params, :status => 'CREDIT FAILED', :approval => 'N'}
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.status.should == "PENDING CREDIT"
      ecol_transaction.pending_approval.should == "N"
    end

    it "updates the requested valdation ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'VALIDATION FAILED', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      put :update_multiple, {:ecol_transaction_ids => [ecol_transaction.id], :ecol_transaction => params, :status => 'VALIDATION FAILED', :approval => 'N'}
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.status.should == "PENDING VALIDATION"
      ecol_transaction.pending_approval.should == "N"
    end

    it "updates the requested valdation ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :settle_status => 'SETTLEMENT FAILED', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      put :update_multiple, {:ecol_transaction_ids => [ecol_transaction.id], :ecol_transaction => params, :settle_status => 'SETTLEMENT FAILED', :approval => 'N'}
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.settle_status.should == "PENDING SETTLEMENT"
      ecol_transaction.pending_approval.should == "N"
    end

    it "updates the requested valdation ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :notify_status => 'NOTIFICATION FAILED', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      put :update_multiple, {:ecol_transaction_ids => [ecol_transaction.id], :ecol_transaction => params, :notify_status => 'NOTIFICATION FAILED', :approval => 'N'}
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.notify_status.should == "PENDING NOTIFICATION"
      ecol_transaction.pending_approval.should == "N"
    end
  end

  describe "PUT approve_transaction" do
    it "updates the requested credit ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'PENDING CREDIT', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      put :approve_transaction, :id => ecol_transaction.id
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.pending_approval.should == "N"
    end

    it "updates the requested return ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'PENDING RETURN', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      put :approve_transaction, :id => ecol_transaction.id
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.pending_approval.should == "N"
    end

    it "updates the requested return ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'PENDING RETURN', :transfer_unique_no => "vvvvv", :pending_approval => 'N')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      put :approve_transaction, :id => ecol_transaction.id
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.pending_approval.should == "N"
      flash[:notice].should  match(/Transaction is already approved/)
    end
  end

  describe "PUT update" do
    it "updates the requested credit ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'CREDIT FAILED', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      put :update, :id => ecol_transaction.id, :state => 'CREDIT'
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.status.should == 'PENDING CREDIT'
      ecol_transaction.pending_approval.should == 'N'
    end

    it "updates the requested return ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'RETURN FAILED', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      put :update, :id => ecol_transaction.id, :state => 'RETURN'
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.status.should == 'PENDING RETURN'
      ecol_transaction.pending_approval.should == 'N'
    end

    it "updates the requested credit ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'VALIDATION ERROR', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      put :update, :id => ecol_transaction.id, :state => 'VALIDATION'
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.status.should == 'PENDING VALIDATION'
      ecol_transaction.validation_status.should == 'PENDING VALIDATION'
      ecol_transaction.pending_approval.should == 'N'
    end

    it "updates the requested return ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :settle_status => 'SETTLEMENT FAILED', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      put :update, :id => ecol_transaction.id, :state => 'SETTLEMENT'
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.settle_status.should == 'PENDING SETTLEMENT'
      ecol_transaction.pending_approval.should == 'N'
    end

    it "updates the requested return ecol_transactions" do
      ecol_transaction = Factory(:ecol_transaction, :settle_status => 'NOTIFICATION FAILED', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      put :update, :id => ecol_transaction.id, :state => 'NOTIFICATION'
      response.should be_redirect
      ecol_transaction.reload
      ecol_transaction.notify_status.should == 'PENDING NOTIFICATION'
      ecol_transaction.pending_approval.should == 'N'
    end
  end

  describe "GET ecol_audit_logs" do
    it "returns the credit log" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'CREDIT FAILED', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      log = Factory(:ecol_audit_log, :ecol_transaction_id => ecol_transaction.id, :step_name => 'CREDIT')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      get :ecol_audit_logs, :id => ecol_transaction.id, :step_name => 'CREDIT'
      assigns[:ecol_values].should == [log]
    end

    it "returns the credit log" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'RETURN FAILED', :transfer_unique_no => "vvvvv", :pending_approval => 'Y')
      log = Factory(:ecol_audit_log, :ecol_transaction_id => ecol_transaction.id, :step_name => 'RETURN')
      params = ecol_transaction.attributes.slice(*ecol_transaction.class.attribute_names)
      get :ecol_audit_logs, :id => ecol_transaction.id, :step_name => 'RETURN'
      assigns[:ecol_values].should == [log]
    end
  end
end
