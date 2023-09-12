require 'spec_helper'

describe UdfAttributesController do
  include HelperMethods
  
  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
  end
  
  describe "GET new" do
    it "assigns a new udf_attribute as @udf_attribute" do
      get :new
      assigns(:udf_attribute).should be_a_new(UdfAttribute)
    end
  end
  
  describe "GET show" do
    it "assigns the requested udf_attribute as @udf_attribute" do
      udf_attribute = Factory(:udf_attribute)
      get :show, {:id => udf_attribute.id}
      assigns(:udf_attribute).should eq(udf_attribute)
    end
  end
  
  describe "GET index" do
    it "assigns all udf_attributes as @udf_attributes" do
      udf_attribute = Factory(:udf_attribute,:approval_status => 'A')
      get :index
      assigns(:udf_attributes).should eq([udf_attribute])
    end

    it "assigns all unapproved udf_attributes as @udf_attributes when approval_status is passed" do
      udf_attribute = Factory(:udf_attribute, :approval_status => 'U')
      get :index, :approval_status => 'U'
      assigns(:udf_attributes).should eq([udf_attribute])
    end
  end
  
  describe "GET edit" do
    it "assigns the requested udf_attribute as @udf_attribute" do
      udf_attribute = Factory(:udf_attribute)
      get :edit, {:id => udf_attribute.id}
      assigns(:udf_attribute).should eq(udf_attribute)
    end

    it "assigns the requested udf_attribute with status 'A' as @udf_attribute" do
      udf_attribute = Factory(:udf_attribute,:approval_status => 'A')
      get :edit, {:id => udf_attribute.id}
      assigns(:udf_attribute).should eq(udf_attribute)
    end

    it "assigns the new udf_attribute with requested udf_attribute params when status 'A' as @udf_attribute" do
      udf_attribute = Factory(:udf_attribute,:approval_status => 'A')
      params = (udf_attribute.attributes).merge({:approved_id => udf_attribute.id,:approved_version => udf_attribute.lock_version})
      get :edit, {:id => udf_attribute.id}
      assigns(:udf_attribute).should eq(UdfAttribute.new(params))
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "creates a new udf_attribute" do
        params = Factory.attributes_for(:udf_attribute)
        expect {
          post :create, {:udf_attribute => params}
        }.to change(UdfAttribute.unscoped, :count).by(1)
        flash[:alert].should  match(/Udf successfully created/)
        response.should be_redirect
      end

      it "assigns a newly created udf_attribute as @udf_attribute" do
        params = Factory.attributes_for(:udf_attribute)
        post :create, {:udf_attribute => params}
        assigns(:udf_attribute).should be_a(UdfAttribute)
        assigns(:udf_attribute).should be_persisted
      end

      it "redirects to the created udf_attribute" do
        params = Factory.attributes_for(:udf_attribute)
        post :create, {:udf_attribute => params}
        response.should redirect_to(UdfAttribute.unscoped.last)
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved udf_attribute as @udf_attribute" do
        params = Factory.attributes_for(:udf_attribute)
        params[:class_name] = nil
        expect {
          post :create, {:udf_attribute => params}
        }.to change(UdfAttribute, :count).by(0)
        assigns(:udf_attribute).should be_a(UdfAttribute)
        assigns(:udf_attribute).should_not be_persisted
      end

      it "re-renders the 'new' template when show_errors is true" do
        params = Factory.attributes_for(:udf_attribute)
        params[:class_name] = nil
        post :create, {:udf_attribute => params}
        response.should render_template("new")
      end
    end
  end
  
  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested udf_attribute" do
        udf_attribute = Factory(:udf_attribute, :class_name => "EcolRemitter")
        params = udf_attribute.attributes.slice(*udf_attribute.class.attribute_names)
        params[:class_name] = "EcolCustomer"
        put :update, {:id => udf_attribute.id, :udf_attribute => params}
        udf_attribute.reload
        udf_attribute.class_name.should == "EcolCustomer"
      end

      it "assigns the requested udf_attribute as @udf_attribute" do
        udf_attribute = Factory(:udf_attribute, :class_name => "EcolRemitter")
        params = udf_attribute.attributes.slice(*udf_attribute.class.attribute_names)
        params[:class_name] = "EcolCustomer"
        put :update, {:id => udf_attribute.to_param, :udf_attribute => params}
        assigns(:udf_attribute).should eq(udf_attribute)
      end

      it "redirects to the udf_attribute" do
        udf_attribute = Factory(:udf_attribute, :class_name => "EcolRemitter")
        params = udf_attribute.attributes.slice(*udf_attribute.class.attribute_names)
        params[:class_name] = "EcolCustomer"
        put :update, {:id => udf_attribute.to_param, :udf_attribute => params}
        response.should redirect_to(udf_attribute)
      end
      
      it "should raise error when tried to update at same time by many" do
        udf_attribute = Factory(:udf_attribute, :class_name => "EcolRemitter")
        params = udf_attribute.attributes.slice(*udf_attribute.class.attribute_names)
        params[:class_name] = "EcolCustomer"
        udf_attribute2 = udf_attribute
        put :update, {:id => udf_attribute.id, :udf_attribute => params}
        udf_attribute.reload
        udf_attribute.class_name.should == "EcolCustomer"
        params[:class_name] = "EcolTransaction"
        put :update, {:id => udf_attribute2.id, :udf_attribute => params}
        udf_attribute.reload
        udf_attribute.class_name.should == "EcolCustomer"
        flash[:alert].should  match(/Someone edited the udf the same time you did. Please re-apply your changes to the udf/)
      end
    end

    describe "with invalid params" do
      it "assigns the udf_attribute as @udf_attribute" do
        udf_attribute = Factory(:udf_attribute, :class_name => "CUST01")
        params = udf_attribute.attributes.slice(*udf_attribute.class.attribute_names)
        params[:class_name] = nil
        put :update, {:id => udf_attribute.to_param, :udf_attribute => params}
        assigns(:udf_attribute).should eq(udf_attribute)
        udf_attribute.reload
        params[:class_name] = nil
      end

      it "re-renders the 'edit' template when show_errors is true" do
        udf_attribute = Factory(:udf_attribute)
        params = udf_attribute.attributes.slice(*udf_attribute.class.attribute_names)
        params[:class_name] = nil
        put :update, {:id => udf_attribute.id, :udf_attribute => params, :show_errors => "true"}
        response.should render_template("edit")
      end
    end
  end
  
  describe "GET audit_logs" do
    it "assigns the requested udf_attribute as @udf_attribute" do
      udf_attribute = Factory(:udf_attribute)
      get :audit_logs, {:id => udf_attribute.id, :version_id => 0}
      assigns(:udf_attribute).should eq(udf_attribute)
      assigns(:audit).should eq(udf_attribute.audits.first)
      get :audit_logs, {:id => 12345, :version_id => "i"}
      assigns(:udf_attribute).should eq(nil)
      assigns(:audit).should eq(nil)
    end
  end
  
  describe "PUT approve" do
    it "(edit) unapproved record can be approved and old approved record will be updated" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      udf_attribute1 = Factory(:udf_attribute, :approval_status => 'A')
      udf_attribute2 = Factory(:udf_attribute, :class_name => 'EcolRemitter', :approval_status => 'U', :approved_version => udf_attribute1.lock_version, :approved_id => udf_attribute1.id, :created_by => 666)
      # the following line is required for reload to get triggered (TODO)
      udf_attribute1.approval_status.should == 'A'
      UnapprovedRecord.count.should == 1
      put :approve, {:id => udf_attribute2.id}
      UnapprovedRecord.count.should == 0
      udf_attribute1.reload
      udf_attribute1.class_name.should == 'EcolRemitter'
      udf_attribute1.updated_by.should == "666"
      UdfAttribute.find_by_id(udf_attribute2.id).should be_nil
    end

    it "(create) unapproved record can be approved" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      udf_attribute = Factory(:udf_attribute,:class_name => 'EcolRemitter', :approval_status => 'U')
      UnapprovedRecord.count.should == 1
      put :approve, {:id => udf_attribute.id}
      UnapprovedRecord.count.should == 0
      udf_attribute.reload
      udf_attribute.class_name.should == 'EcolRemitter'
      udf_attribute.approval_status.should == 'A'
    end
  end
  
  describe "destroy" do
    it "should destroy the udf_attribute when created_user = current_user" do 
      udf_attribute = Factory(:udf_attribute, :created_by => @user.id)
      UnapprovedRecord.count.should == 1
      delete :destroy, {:id => udf_attribute.id}
      UdfAttribute.unscoped.find_by_id(udf_attribute.id).should be_nil
      UnapprovedRecord.count.should == 0
    end

    it "should not destroy the udf_attribute when created_user != current_user" do 
      udf_attribute = Factory(:udf_attribute, :created_by => 5)
      delete :destroy, {:id => udf_attribute.id}
      flash[:alert].should  match(/You cannot delete this record!/)
      UdfAttribute.unscoped.find_by_id(udf_attribute.id).should_not be_nil
    end
    
    it "should not destroy the ecol_remitter when approval_status = 'A'" do 
      udf_attribute = Factory(:udf_attribute, :approval_status => "A")
      delete :destroy, {:id => udf_attribute.id}
      flash[:alert].should  match(/You cannot delete this record!/)
      UdfAttribute.unscoped.find_by_id(udf_attribute.id).should_not be_nil
    end
  end
end
