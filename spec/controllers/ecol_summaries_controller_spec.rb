require 'spec_helper'

describe EcolSummariesController do
  include HelperMethods
  
  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
    
    mock_ldap
  end

  describe "GET summary" do
    it "renders summary" do
      ecol_transaction = Factory(:ecol_transaction, :status => 'NEW', :pending_approval => 'Y')
      get :index
      assigns(:ecol_transaction_summary).should eq({['NEW','Y']=>1})
      assigns(:ecol_transaction_statuses).should eq(['NEW'])
      assigns(:total_pending_records).should eq(1)
      assigns(:total_records).should eq(1)
    end
  end 
end