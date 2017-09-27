require 'spec_helper'

describe EcolRulesController do
  include HelperMethods
  
  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ecol_rule" do
        params = Factory.attributes_for(:ecol_rule)
        expect {
          post :create, {:ecol_rule => params}
        }.to change(EcolRule.unscoped, :count).by(1)
        flash[:alert].should  match(/Rule successfully created/)
        response.should be_redirect
      end

      it "assigns a newly created ecol_rule as @ecol_rule" do
        params = Factory.attributes_for(:ecol_rule)
        post :create, {:ecol_rule => params}
        assigns(:ecol_rule).should be_a(EcolRule)
        assigns(:ecol_rule).should be_persisted
      end

      it "redirects to the created ecol_rule" do
        params = Factory.attributes_for(:ecol_rule)
        post :create, {:ecol_rule => params}
        response.should redirect_to(EcolRule.unscoped.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved ecol_rule as @ecol_rule" do
        params = Factory.attributes_for(:ecol_rule)
        params[:ifsc] = nil
        expect {
          post :create, {:ecol_rule => params}
        }.to change(EcolRule, :count).by(0)
        assigns(:ecol_rule).should be_a(EcolRule)
        assigns(:ecol_rule).should_not be_persisted
      end

      it "re-renders the 'new' template when show_errors is true" do
        params = Factory.attributes_for(:ecol_rule)
        params[:ifsc] = nil
        post :create, {:ecol_rule => params}
        response.should render_template("new")
      end
    end
  end

  describe "GET index" do
    it "assigns all ecol_rules with approval_status 'U' as @ecol_rules" do
      ecol_rule1 = Factory(:ecol_rule, :approval_status => 'A')
      ecol_rule2 = Factory(:ecol_rule, :approval_status => 'U')
      get :index
      assigns(:ecol_rules).should eq([ecol_rule2])
    end
  end

  describe "GET show" do
    it "assigns the requested rule as @ecol_rule" do
      ecol_rule = Factory(:ecol_rule)
      get :show, {:id => ecol_rule.id}
      assigns(:ecol_rule).should eq(ecol_rule)
    end
  end
  
  describe "GET edit" do
    it "assigns the requested rule as @ecol_rule" do
      ecol_rule = Factory(:ecol_rule)
      get :edit, {:id => ecol_rule.id}
      assigns(:ecol_rule).should eq(ecol_rule)
    end

    it "assigns the requested ecol_rule with status 'A' as @ecol_rule" do
      ecol_rule = Factory(:ecol_rule,:approval_status => 'A')
      get :edit, {:id => ecol_rule.id}
      assigns(:ecol_rule).should eq(ecol_rule)
    end

    it "assigns the new ecol_rule with requested ecol_rule params when status 'A' as @ecol_rule" do
      ecol_rule = Factory(:ecol_rule,:approval_status => 'A')
      params = (ecol_rule.attributes).merge({:approved_id => ecol_rule.id,:approved_version => ecol_rule.lock_version})
      get :edit, {:id => ecol_rule.id}
      assigns(:ecol_rule).should eq(EcolRule.new(params))
    end
  end
  
  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested rule" do
        ecol_rule = Factory(:ecol_rule, :ifsc => "ABCD0QWERTY")
        params = ecol_rule.attributes.slice(*ecol_rule.class.attribute_names)
        params[:ifsc] = "CDAB0QWERTY"
        put :update, {:id => ecol_rule.id, :ecol_rule => params}
        ecol_rule.reload
        ecol_rule.ifsc.should == "CDAB0QWERTY"
      end

      it "assigns the requested rule as @ecol_rule" do
        ecol_rule = Factory(:ecol_rule, :ifsc => "ABCD0QWERTY")
        params = ecol_rule.attributes.slice(*ecol_rule.class.attribute_names)
        params[:ifsc] = "CDAB0QWERTY"
        put :update, {:id => ecol_rule.to_param, :ecol_rule => params}
        assigns(:ecol_rule).should eq(ecol_rule)
      end

      it "redirects to the rule" do
        ecol_rule = Factory(:ecol_rule, :ifsc => "ABCD0QWERTY")
        params = ecol_rule.attributes.slice(*ecol_rule.class.attribute_names)
        params[:ifsc] = "CDAB0QWERTY"
        put :update, {:id => ecol_rule.to_param, :ecol_rule => params}
        response.should redirect_to(ecol_rule)
      end

      it "should raise error when tried to update at same time by many" do
        ecol_rule = Factory(:ecol_rule, :ifsc => "ORGV0123456")
        
        # update once
        params = ecol_rule.attributes.slice(*ecol_rule.class.attribute_names)
        params[:ifsc] = "UPDA0123456"
        put :update, {:id => ecol_rule.id, :ecol_rule => params}

        # update another time, without a reload, this will fail as the lock_version has changed 
        params = ecol_rule.attributes.slice(*ecol_rule.class.attribute_names)
        params[:ifsc] = "UPDB0123456"
        put :update, {:id => ecol_rule.id, :ecol_rule => params}
        flash[:alert].should  match(/Someone edited the rule the same time you did. Please re-apply your changes to the rule/)
      end
    end
  end

  describe "GET audit_logs" do
    it "assigns the requested rule as @ecol_rule" do
      ecol_rule = Factory(:ecol_rule)
      get :audit_logs, {:id => ecol_rule.id, :version_id => 0}
      assigns(:ecol_rule).should eq(ecol_rule)
      assigns(:audit).should eq(ecol_rule.audits.first)
      get :audit_logs, {:id => 12345, :version_id => "e"}
      assigns(:ecol_rule).should eq(nil)
      assigns(:audit).should eq(nil)
    end
  end

  describe "GET error_msg" do
    it "displays the flash msg and redirects to root" do
      ecol_rule = Factory(:ecol_rule)
      get :error_msg
      flash[:alert].should  match(/Rule is not yet configured/)
      response.should redirect_to(:root)
    end
  end

  describe "PUT approve" do
    it "(edit) unapproved record can be approved and old approved record will be updated" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      ecol_rule1 = Factory(:ecol_rule, :approval_status => 'A')
      ecol_rule2 = Factory(:ecol_rule, :stl_gl_inward => '9876543210', :approval_status => 'U', :approved_version => ecol_rule1.lock_version, :approved_id => ecol_rule1.id, :created_by => 666)
      # the following line is required for reload to get triggered (TODO)
      ecol_rule1.approval_status.should == 'A'
      UnapprovedRecord.count.should == 1
      put :approve, {:id => ecol_rule2.id}
      UnapprovedRecord.count.should == 0
      ecol_rule1.reload
      ecol_rule1.stl_gl_inward.should == '9876543210'
      ecol_rule1.updated_by.should == "666"
      EcolRule.find_by_id(ecol_rule2.id).should be_nil
    end

    it "(create) unapproved record can be approved" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      ecol_rule = Factory(:ecol_rule, :stl_gl_inward => '9876543210', :approval_status => 'U')
      UnapprovedRecord.count.should == 1
      put :approve, {:id => ecol_rule.id}
      UnapprovedRecord.count.should == 0
      ecol_rule.reload
      ecol_rule.stl_gl_inward.should == '9876543210'
      ecol_rule.approval_status.should == 'A'
    end
  end
  
  describe "destroy" do
    it "should destroy the ecol_remitter when created_user = current_user" do 
      ecol_rule = Factory(:ecol_rule, :created_by => @user.id)
      UnapprovedRecord.count.should == 1
      delete :destroy, {:id => ecol_rule.id}
      EcolRule.unscoped.find_by_id(ecol_rule.id).should be_nil
      UnapprovedRecord.count.should == 0
    end

    it "should not destroy the ecol_remitter when created_user != current_user" do 
      ecol_rule = Factory(:ecol_rule, :created_by => 5)
      delete :destroy, {:id => ecol_rule.id}
      flash[:alert].should  match(/You cannot delete this record!/)
      EcolRule.unscoped.find_by_id(ecol_rule.id).should_not be_nil
    end
    
    it "should not destroy the ecol_remitter when approval_status = 'A'" do 
      ecol_remitter = Factory(:ecol_rule, :approval_status => "A")
      delete :destroy, {:id => ecol_remitter.id}
      flash[:alert].should  match(/You cannot delete this record!/)
      EcolRule.unscoped.find_by_id(ecol_remitter.id).should_not be_nil
    end
  end
end
