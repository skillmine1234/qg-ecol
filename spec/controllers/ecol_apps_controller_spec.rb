require 'spec_helper'

describe EcolAppsController do
  include HelperMethods
  
  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
  end
  
  describe "GET new" do
    it "assigns a new ecol_app as @ecol_app" do
      get :new
      assigns(:ecol_app).should be_a_new(EcolApp)
    end
  end

  describe "GET show" do
    it "assigns the requested ecol_app as @ecol_app" do
      ecol_app = Factory(:ecol_app)
      get :show, {:id => ecol_app.id}
      assigns(:ecol_app).should eq(ecol_app)
    end
  end
  
  describe "GET index" do
    it "assigns all ecol_apps as @ecol_apps" do
      ecol_app = Factory(:ecol_app, :approval_status => 'A')
      get :index
      assigns(:ecol_apps).should eq([ecol_app])
    end
    
    it "assigns all unapproved ecol_apps as @ecol_apps when approval_status is passed" do
      ecol_app = Factory(:ecol_app, :approval_status => 'U')
      get :index, :approval_status => 'U'
      assigns(:ecol_apps).should eq([ecol_app])
    end
  end
  
  describe "GET edit" do
    it "assigns the requested ecol_app as @ecol_app" do
      ecol_app = Factory(:ecol_app, :approval_status => 'A')
      get :edit, {:id => ecol_app.id}
      assigns(:ecol_app).should eq(ecol_app)
    end
    
    it "assigns the requested ecol_app with status 'A' as @ecol_app" do
      ecol_app = Factory(:ecol_app,:approval_status => 'A')
      get :edit, {:id => ecol_app.id}
      assigns(:ecol_app).should eq(ecol_app)
    end

    it "assigns the new ecol_app with requested ecol_app params when status 'A' as @ecol_app" do
      ecol_app = Factory(:ecol_app,:approval_status => 'A')
      params = (ecol_app.attributes).merge({:approved_id => ecol_app.id,:approved_version => ecol_app.lock_version})
      get :edit, {:id => ecol_app.id}
      assigns(:ecol_app).should eq(EcolApp.new(params))
    end
  end
  
  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested ecol_app" do
        ecol_app = Factory(:ecol_app, :notify_url => "http://localhost")
        params = ecol_app.attributes.slice(*ecol_app.class.attribute_names)
        params[:notify_url] = "https://www.google.com"
        put :update, {:id => ecol_app.id, :ecol_app => params}
        ecol_app.reload
        ecol_app.notify_url.should == "https://www.google.com"
      end

      it "assigns the requested ecol_app as @ecol_app" do
        ecol_app = Factory(:ecol_app, :notify_url => "http://localhost")
        params = ecol_app.attributes.slice(*ecol_app.class.attribute_names)
        params[:notify_url] = "https://www.google.com"
        put :update, {:id => ecol_app.to_param, :ecol_app => params}
        assigns(:ecol_app).should eq(ecol_app)
      end

      it "redirects to the ecol_app" do
        ecol_app = Factory(:ecol_app, :notify_url => "http://localhost")
        params = ecol_app.attributes.slice(*ecol_app.class.attribute_names)
        params[:notify_url] = "https://www.google.com"
        put :update, {:id => ecol_app.to_param, :ecol_app => params}
        response.should redirect_to(ecol_app)
      end

      it "should raise error when tried to update at same time by many" do
        ecol_app = Factory(:ecol_app, :notify_url => "http://localhost")
        params = ecol_app.attributes.slice(*ecol_app.class.attribute_names)
        params[:notify_url] = "https://www.google.com"
        ecol_app2 = ecol_app
        put :update, {:id => ecol_app.id, :ecol_app => params}
        ecol_app.reload
        ecol_app.notify_url.should == "https://www.google.com"
        params[:notify_url] = "https://www.yahoo.com"
        put :update, {:id => ecol_app2.id, :ecol_app => params}
        ecol_app.reload
        ecol_app.notify_url.should == "https://www.google.com"
        flash[:alert].should  match(/Someone edited the ecol_app the same time you did. Please re-apply your changes to the ecol_app/)
      end
    end

    describe "with invalid params" do
      it "assigns the ecol_app as @ecol_app" do
        ecol_app = Factory(:ecol_app, :notify_url => "http://localhost")
        params = ecol_app.attributes.slice(*ecol_app.class.attribute_names)
        params[:notify_url] = nil
        put :update, {:id => ecol_app.to_param, :ecol_app => params}
        assigns(:ecol_app).should eq(ecol_app)
        ecol_app.reload
        params[:notify_url] = nil
      end

      it "re-renders the 'edit' template when show_errors is true" do
        ecol_app = Factory(:ecol_app)
        params = ecol_app.attributes.slice(*ecol_app.class.attribute_names)
        params[:http_username] = 'abc'
        params[:http_password] = nil
        put :update, {:id => ecol_app.id, :ecol_app => params, :show_errors => "true"}
        response.should render_template("edit")
      end
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "creates a new ecol_app" do
        params = Factory.attributes_for(:ecol_app)
        expect {
          post :create, {:ecol_app => params}
        }.to change(EcolApp.unscoped, :count).by(1)
        flash[:alert].should  match(/Ecol App successfully created and is pending for approval/)
        response.should be_redirect
      end

      it "assigns a newly created ecol_app as @ecol_app" do
        params = Factory.attributes_for(:ecol_app)
        post :create, {:ecol_app => params}
        assigns(:ecol_app).should be_a(EcolApp)
        assigns(:ecol_app).should be_persisted
      end

      it "redirects to the created ecol_app" do
        params = Factory.attributes_for(:ecol_app)
        post :create, {:ecol_app => params}
        response.should redirect_to(EcolApp.unscoped.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved ecol_app as @ecol_app" do
        params = Factory.attributes_for(:ecol_app)
        params[:http_username] = 'abc'
        params[:http_password] = nil
        expect {
          post :create, {:ecol_app => params}
        }.to change(EcolApp, :count).by(0)
        assigns(:ecol_app).should be_a(EcolApp)
        assigns(:ecol_app).should_not be_persisted
      end

      it "re-renders the 'new' template when show_errors is true" do
        params = Factory.attributes_for(:ecol_app)
        params[:http_username] = 'abc'
        params[:http_password] = nil
        post :create, {:ecol_app => params}
        response.should render_template("new")
      end
    end
  end
  
  describe "PUT approve" do
    it "(edit) unapproved record can be approved and old approved record will be updated" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      ecol_app1 = Factory(:ecol_app, :approval_status => 'A')
      ecol_app2 = Factory(:ecol_app, :approval_status => 'U', :notify_url => "http://localhost", :approved_version => ecol_app1.lock_version, :approved_id => ecol_app1.id, :created_by => 666)
      # the following line is required for reload to get triggered (TODO)
      ecol_app1.approval_status.should == 'A'
      UnapprovedRecord.count.should == 1
      put :approve, {:id => ecol_app2.id}
      UnapprovedRecord.count.should == 0
      ecol_app1.reload
      ecol_app1.notify_url.should == 'http://localhost'
      ecol_app1.updated_by.should == "666"
      UnapprovedRecord.find_by_id(ecol_app2.id).should be_nil
    end
  end
  
  describe "GET audit_logs" do
    it "assigns the requested ecol_app as @ecol_app" do
      ecol_app = Factory(:ecol_app)
      get :audit_logs, {:id => ecol_app.id, :version_id => 0}
      assigns(:record).should eq(ecol_app)
      assigns(:audit).should eq(ecol_app.audits.first)
      get :audit_logs, {:id => 12345, :version_id => "i"}
      assigns(:record).should eq(nil)
      assigns(:audit).should eq(nil)
    end
  end
  
  describe "GET ecol_app_udtables" do
    it "assigns all ecol_app_udtables for an app_code as @records" do
      ecol_app = Factory(:ecol_app, :approval_status => 'A')
      ecol_app_udtable = Factory(:ecol_app_udtable, app_code: ecol_app.app_code, :approval_status => 'A')
      get :ecol_app_udtables, app_code: ecol_app.app_code
      assigns(:records).should eq([ecol_app_udtable])
    end
  end
end
