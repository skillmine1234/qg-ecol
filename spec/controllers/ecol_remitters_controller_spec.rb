require 'spec_helper'

describe EcolRemittersController do
  include HelperMethods
  
  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
    
    mock_ldap
  end
  
  describe "GET index" do
    it "assigns all ecol_remitters as @ecol_remitters" do
      ecol_remitter = Factory(:ecol_remitter, :approval_status => 'A')
      get :index
      assigns(:ecol_remitters).should eq([ecol_remitter])
    end

    it "assigns all unapproved ecol_remitter as @ecol_remitters when approval_status is passed" do
      ecol_remitter = Factory(:ecol_remitter, :approval_status => 'U')
      get :index, :approval_status => 'U'
      assigns(:ecol_remitters).should eq([ecol_remitter])
    end
  end
  
  describe "GET show" do
    it "assigns the requested ecol_remitter as @ecol_remitter" do
      ecol_remitter = Factory(:ecol_remitter)
      get :show, {:id => ecol_remitter.id}
      assigns(:ecol_remitter).should eq(ecol_remitter)
    end
  end

  describe "GET new" do
    it "assigns a new ecol_remitter as @ecol_remitter" do
      get :new
      assigns(:ecol_remitter).should be_a_new(EcolRemitter)
    end
  end

  describe "GET edit" do
    it "assigns the requested ecol_remitter as @ecol_remitter" do
      ecol_remitter = Factory(:ecol_remitter)
      get :edit, {:id => ecol_remitter.id}
      assigns(:ecol_remitter).should eq(ecol_remitter)
    end

    it "assigns the requested ecol_remitter with status 'A' as @ecol_remitter" do
      ecol_remitter = Factory(:ecol_remitter,:approval_status => 'A')
      get :edit, {:id => ecol_remitter.id}
      assigns(:ecol_remitter).should eq(ecol_remitter)
    end

    it "assigns the new ecol_remitter with requested ecol_remitter params when status 'A' as @ecol_remitter" do
      ecol_remitter = Factory(:ecol_remitter,:approval_status => 'A')
      params = (ecol_remitter.attributes).merge({:approved_id => ecol_remitter.id,:approved_version => ecol_remitter.lock_version})
      get :edit, {:id => ecol_remitter.id}
      assigns(:ecol_remitter).should eq(EcolRemitter.new(params))
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "creates a new ecol_remitter" do
        params = Factory.attributes_for(:ecol_remitter)
        expect {
          post :create, {:ecol_remitter => params}
        }.to change(EcolRemitter.unscoped, :count).by(1)
        flash[:alert].should  match(/Remitter successfully created/)
        response.should be_redirect
      end

      it "assigns a newly created ecol_remitter as @ecol_remitter" do
        params = Factory.attributes_for(:ecol_remitter)
        post :create, {:ecol_remitter => params}
        assigns(:ecol_remitter).should be_a(EcolRemitter)
        assigns(:ecol_remitter).should be_persisted
      end

      it "redirects to the created ecol_remitter" do
        params = Factory.attributes_for(:ecol_remitter)
        post :create, {:ecol_remitter => params}
        response.should redirect_to(EcolRemitter.unscoped.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved ecol_remitter as @ecol_remitter" do
        params = Factory.attributes_for(:ecol_remitter)
        params[:customer_code] = nil
        expect {
          post :create, {:ecol_remitter => params}
        }.to change(EcolRemitter, :count).by(0)
        assigns(:ecol_remitter).should be_a(EcolRemitter)
        assigns(:ecol_remitter).should_not be_persisted
      end

      it "re-renders the 'new' template when show_errors is true" do
        params = Factory.attributes_for(:ecol_remitter)
        params[:customer_code] = nil
        post :create, {:ecol_remitter => params}
        response.should render_template("new")
      end
    end
  end
  
  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested ecol_remitter" do
        ecol_remitter = Factory(:ecol_remitter, :customer_subcode => "CUST01")
        params = ecol_remitter.attributes.slice(*ecol_remitter.class.attribute_names)
        params[:customer_subcode] = "CUST02"
        put :update, {:id => ecol_remitter.id, :ecol_remitter => params}
        ecol_remitter.reload
        ecol_remitter.customer_subcode.should == "CUST02"
      end

      it "assigns the requested ecol_remitter as @ecol_remitter" do
        ecol_remitter = Factory(:ecol_remitter, :customer_subcode => "CUST01")
        params = ecol_remitter.attributes.slice(*ecol_remitter.class.attribute_names)
        params[:customer_subcode] = "CUST02"
        put :update, {:id => ecol_remitter.to_param, :ecol_remitter => params}
        assigns(:ecol_remitter).should eq(ecol_remitter)
      end

      it "redirects to the ecol_remitter" do
        ecol_remitter = Factory(:ecol_remitter, :customer_subcode => "CUST01")
        params = ecol_remitter.attributes.slice(*ecol_remitter.class.attribute_names)
        params[:customer_subcode] = "CUST02"
        put :update, {:id => ecol_remitter.to_param, :ecol_remitter => params}
        response.should redirect_to(ecol_remitter)
      end

      it "should raise error when tried to update at same time by many" do
        ecol_remitter = Factory(:ecol_remitter, :customer_subcode => "CUST01")
        params = ecol_remitter.attributes.slice(*ecol_remitter.class.attribute_names)
        params[:customer_subcode] = "CUST02"
        ecol_remitter2 = ecol_remitter
        put :update, {:id => ecol_remitter.id, :ecol_remitter => params}
        ecol_remitter.reload
        ecol_remitter.customer_subcode.should == "CUST02"
        params[:customer_subcode] = "CUST03"
        put :update, {:id => ecol_remitter2.id, :ecol_remitter => params}
        ecol_remitter.reload
        ecol_remitter.customer_subcode.should == "CUST02"
        flash[:alert].should  match(/Someone edited the remitter the same time you did. Please re-apply your changes to the remitter/)
      end
    end

    describe "with invalid params" do
      it "assigns the ecol_remitter as @ecol_remitter" do
        ecol_remitter = Factory(:ecol_remitter, :remitter_code => "01")
        params = ecol_remitter.attributes.slice(*ecol_remitter.class.attribute_names)
        params[:remitter_code] = nil
        put :update, {:id => ecol_remitter.to_param, :ecol_remitter => params}
        assigns(:ecol_remitter).should eq(ecol_remitter)
        ecol_remitter.reload
        params[:remitter_code] = nil
      end

      it "re-renders the 'edit' template when show_errors is true" do
        ecol_remitter = Factory(:ecol_remitter)
        params = ecol_remitter.attributes.slice(*ecol_remitter.class.attribute_names)
        params[:customer_code] = nil
        put :update, {:id => ecol_remitter.id, :ecol_remitter => params, :show_errors => "true"}
        response.should render_template("edit")
      end
    end
  end
 
  describe "GET audit_logs" do
   it "assigns the requested ecol_remitter as @ecol_remitter" do
     ecol_remitter = Factory(:ecol_remitter)
     get :audit_logs, {:id => ecol_remitter.id, :version_id => 0}
     assigns(:ecol_remitter).should eq(ecol_remitter)
     assigns(:audit).should eq(ecol_remitter.audits.first)
     get :audit_logs, {:id => 12345, :version_id => "i"}
     assigns(:ecol_remitter).should eq(nil)
     assigns(:audit).should eq(nil)
   end
  end

  describe "PUT approve" do
    it "(edit) unapproved record can be approved and old approved record will be updated" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      ecol_remitter1 = Factory(:ecol_remitter, :approval_status => 'A')
      ecol_remitter2 = Factory(:ecol_remitter, :remitter_code => 'BarFoo', :approval_status => 'U', :approved_version => ecol_remitter1.lock_version, :approved_id => ecol_remitter1.id, :created_by => 666)
      # the following line is required for reload to get triggered (TODO)
      ecol_remitter1.approval_status.should == 'A'
      UnapprovedRecord.count.should == 1
      put :approve, {:id => ecol_remitter2.id}
      UnapprovedRecord.count.should == 0
      ecol_remitter1.reload
      ecol_remitter1.remitter_code.should == 'BARFOO'
      ecol_remitter1.updated_by.should == "666"
      EcolRemitter.find_by_id(ecol_remitter2.id).should be_nil
    end

    it "(create) unapproved record can be approved" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      ecol_remitter = Factory(:ecol_remitter, :remitter_code => 'BarFoo', :approval_status => 'U')
      UnapprovedRecord.count.should == 1
      put :approve, {:id => ecol_remitter.id}
      UnapprovedRecord.count.should == 0
      ecol_remitter.reload
      ecol_remitter.remitter_code.should == 'BARFOO'
      ecol_remitter.approval_status.should == 'A'
    end
  end
  
  describe "destroy" do
    it "should destroy the ecol_remitter when created_user = current_user" do 
      ecol_remitter = Factory(:ecol_remitter, :created_by => @user.id)
      UnapprovedRecord.count.should == 1
      delete :destroy, {:id => ecol_remitter.id}
      EcolRemitter.unscoped.find_by_id(ecol_remitter.id).should be_nil
      UnapprovedRecord.count.should == 0
    end
    
    it "should not destroy the ecol_remitter when created_user != current_user" do 
      ecol_remitter = Factory(:ecol_remitter, :created_by => 5)
      delete :destroy, {:id => ecol_remitter.id}
      flash[:alert].should  match(/You cannot delete this record!/)
      EcolRemitter.unscoped.find_by_id(ecol_remitter.id).should_not be_nil
    end

    it "should not destroy the ecol_remitter when approval_status = 'A'" do 
      ecol_remitter = Factory(:ecol_remitter, :approval_status => "A")
      delete :destroy, {:id => ecol_remitter.id}
      flash[:alert].should  match(/You cannot delete this record!/)
      EcolRemitter.unscoped.find_by_id(ecol_remitter.id).should_not be_nil
    end
  end
end
