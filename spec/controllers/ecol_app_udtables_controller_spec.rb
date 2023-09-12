require 'spec_helper'

describe EcolAppUdtablesController do  
  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
  end

  describe "GET index" do
    it "assigns all ecol_app_udtables as @ecol_app_udtables" do
      ecol_app_udtable = Factory(:ecol_app_udtable, :approval_status => 'A')
      get :index
      assigns(:records).should eq([ecol_app_udtable])
    end

    it "assigns all unapproved ecol_app_udtables as @ecol_app_udtables when approval_status is passed" do
      ecol_app_udtable = Factory(:ecol_app_udtable, :approval_status => 'U')
      get :index, :approval_status => 'U'
      assigns(:records).should eq([ecol_app_udtable])
    end
  end

  describe "GET show" do
    it "assigns the requested ecol_app_udtable as @ecol_app_udtable" do
      ecol_app_udtable = Factory(:ecol_app_udtable)
      get :show, {:id => ecol_app_udtable.id}
      assigns(:ecol_app_udtable).should eq(ecol_app_udtable)
    end
  end

  describe "GET new" do
    it "assigns a new ecol_app_udtable as @ecol_app_udtable" do
      get :new
      assigns(:ecol_app_udtable).should be_a_new(EcolAppUdtable)
    end
  end

  describe "GET edit" do
    it "assigns the requested ecol_app_udtable with status 'U' as @ecol_app_udtable" do
      ecol_app_udtable = Factory(:ecol_app_udtable, :approval_status => 'U')
      get :edit, {:id => ecol_app_udtable.id}
      assigns(:ecol_app_udtable).should eq(ecol_app_udtable)
    end

    it "assigns the requested ecol_app_udtable with status 'A' as @ecol_app_udtable" do
      ecol_app_udtable = Factory(:ecol_app_udtable, :approval_status => 'A')
      get :edit, {:id => ecol_app_udtable.id}
      assigns(:ecol_app_udtable).should eq(ecol_app_udtable)
    end

    it "assigns the new ecol_app_udtable with requested ecol_app_udtable params when status 'A' as @ecol_app_udtable" do
      ecol_app_udtable = Factory(:ecol_app_udtable, :approval_status => 'A')
      params = (ecol_app_udtable.attributes).merge({:approved_id => ecol_app_udtable.id, :approved_version => ecol_app_udtable.lock_version})
      get :edit, {:id => ecol_app_udtable.id}
      assigns(:ecol_app_udtable).should eq(EcolAppUdtable.new(params))
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "creates a new ecol_app_udtable" do
        params = Factory.attributes_for(:ecol_app_udtable)
        expect {
          post :create, {:ecol_app_udtable => params}
        }.to change(EcolAppUdtable.unscoped, :count).by(1)
        flash[:alert].should  match(/Ecol App Udf successfully created and is pending for approval/)
        response.should be_redirect
      end

      it "assigns a newly created ecol_app_udtable as @ecol_app_udtable" do
        params = Factory.attributes_for(:ecol_app_udtable)
        post :create, {:ecol_app_udtable => params}
        assigns(:ecol_app_udtable).should be_a(EcolAppUdtable)
        assigns(:ecol_app_udtable).should be_persisted
      end

      it "redirects to the created ecol_app_udtable" do
        params = Factory.attributes_for(:ecol_app_udtable)
        post :create, {:ecol_app_udtable => params}
        response.should redirect_to(EcolAppUdtable.unscoped.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved ecol_app_udtable as @ecol_app_udtable" do
        params = Factory.attributes_for(:ecol_app_udtable)
        params[:app_code] = nil
        expect {
          post :create, {:ecol_app_udtable => params}
        }.to change(EcolAppUdtable, :count).by(0)
        assigns(:ecol_app_udtable).should be_a(EcolAppUdtable)
        assigns(:ecol_app_udtable).should_not be_persisted
      end

      it "re-renders the 'new' template when show_errors is true" do
        params = Factory.attributes_for(:ecol_app_udtable)
        params[:app_code] = nil
        post :create, {:ecol_app_udtable => params}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested ecol_app_udtable" do
        ecol_app_udtable = Factory(:ecol_app_udtable, :udf1 => "Foo")
        params = ecol_app_udtable.attributes.slice(*ecol_app_udtable.class.attribute_names)
        params[:udf1] = "Bar"
        put :update, {:id => ecol_app_udtable.id, :ecol_app_udtable => params}
        ecol_app_udtable.reload
        ecol_app_udtable.udf1.should == "Bar"
      end

      it "assigns the requested ecol_app_udtable as @ecol_app_udtable" do
        ecol_app_udtable = Factory(:ecol_app_udtable, :udf1 => "Foo")
        params = ecol_app_udtable.attributes.slice(*ecol_app_udtable.class.attribute_names)
        params[:udf1] = "Bar"
        put :update, {:id => ecol_app_udtable.to_param, :ecol_app_udtable => params}
        assigns(:ecol_app_udtable).should eq(ecol_app_udtable)
      end

      it "redirects to the ecol_app_udtable" do
        ecol_app_udtable = Factory(:ecol_app_udtable, :udf1 => "Foo")
        params = ecol_app_udtable.attributes.slice(*ecol_app_udtable.class.attribute_names)
        params[:udf1] = "Bar"
        put :update, {:id => ecol_app_udtable.to_param, :ecol_app_udtable => params}
        response.should redirect_to(ecol_app_udtable)
      end

      it "should raise error when tried to update at same time by many" do
        ecol_app_udtable = Factory(:ecol_app_udtable, :udf1 => "Foo")
        params = ecol_app_udtable.attributes.slice(*ecol_app_udtable.class.attribute_names)
        params[:udf1] = "Bar"
        ecol_app_udtable2 = ecol_app_udtable
        put :update, {:id => ecol_app_udtable.id, :ecol_app_udtable => params}
        ecol_app_udtable.reload
        ecol_app_udtable.udf1.should == "Bar"
        params[:udf1] = "Jim"
        put :update, {:id => ecol_app_udtable2.id, :ecol_app_udtable => params}
        ecol_app_udtable.reload
        ecol_app_udtable.udf1.should == "Bar"
        flash[:alert].should  match(/Someone edited the Ecol App Udf the same time you did. Please re-apply your changes to the Ecol App Udf./)
      end
    end

    describe "with invalid params" do
      it "assigns the ecol_app_udtable as @ecol_app_udtable" do
        ecol_app_udtable = Factory(:ecol_app_udtable, :udf1 => "Foo")
        params = ecol_app_udtable.attributes.slice(*ecol_app_udtable.class.attribute_names)
        params[:udf1] = nil
        put :update, {:id => ecol_app_udtable.to_param, :ecol_app_udtable => params}
        assigns(:ecol_app_udtable).should eq(ecol_app_udtable)
        ecol_app_udtable.reload
        params[:app_code] = nil
      end

      it "re-renders the 'edit' template when show_errors is true" do
        ecol_app_udtable = Factory(:ecol_app_udtable)
        params = ecol_app_udtable.attributes.slice(*ecol_app_udtable.class.attribute_names)
        params[:app_code] = nil
        put :update, {:id => ecol_app_udtable.id, :ecol_app_udtable => params, :show_errors => "true"}
        response.should render_template("edit")
      end
    end
  end
 
  describe "GET audit_logs" do
    it "assigns the requested ecol_app_udtable as @ecol_app_udtable" do
      ecol_app_udtable = Factory(:ecol_app_udtable)
      get :audit_logs, {:id => ecol_app_udtable.id, :version_id => 0}
      assigns(:record).should eq(ecol_app_udtable)
      assigns(:audit).should eq(ecol_app_udtable.audits.first)
      get :audit_logs, {:id => 12345, :version_id => "i"}
      assigns(:record).should eq(nil)
      assigns(:audit).should eq(nil)
    end
  end

  describe "PUT approve" do
    it "(edit) unapproved record can be approved and old approved record will be updated" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      ecol_app_udtable1 = Factory(:ecol_app_udtable, :approval_status => 'A')
      ecol_app_udtable2 = Factory(:ecol_app_udtable, :approval_status => 'U', :udf1 => 'Foo', :approved_version => ecol_app_udtable1.lock_version, :approved_id => ecol_app_udtable1.id, :created_by => 666)
      # the following line is required for reload to get triggered (TODO)
      ecol_app_udtable1.approval_status.should == 'A'
      UnapprovedRecord.count.should == 1
      put :approve, {:id => ecol_app_udtable2.id}
      UnapprovedRecord.count.should == 0
      ecol_app_udtable1.reload
      ecol_app_udtable1.udf1.should == 'Foo'
      ecol_app_udtable1.updated_by.should == "666"
      UnapprovedRecord.find_by_id(ecol_app_udtable2.id).should be_nil
    end

    it "(create) unapproved record can be approved" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      ecol_app_udtable = Factory(:ecol_app_udtable, :udf1 => 'Foo', :approval_status => 'U')
      UnapprovedRecord.count.should == 1
      put :approve, {:id => ecol_app_udtable.id}
      UnapprovedRecord.count.should == 0
      ecol_app_udtable.reload
      ecol_app_udtable.udf1.should == 'Foo'
      ecol_app_udtable.approval_status.should == 'A'
    end
  end
end
