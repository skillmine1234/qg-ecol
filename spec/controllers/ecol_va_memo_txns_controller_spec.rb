require 'spec_helper'

describe EcolVaMemoTxnsController do
  include HelperMethods
  
  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
  end
  
  describe "GET new" do
    it "assigns a new ecol_va_memo_txn as @ecol_va_memo_txn" do
      get :new
      assigns(:ecol_va_memo_txn).should be_a_new(EcolVaMemoTxn)
    end
  end

  describe "GET show" do
    it "assigns the requested ecol_va_memo_txn as @ecol_va_memo_txn" do
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn)
      get :show, {:id => ecol_va_memo_txn.id}
      assigns(:ecol_va_memo_txn).should eq(ecol_va_memo_txn)
    end
  end
  
  describe "GET index" do
    it "assigns all ecol_va_memo_txns as @ecol_va_memo_txns" do
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn, :approval_status => 'A')
      get :index
      assigns(:records).should eq([ecol_va_memo_txn])
    end
    
    it "assigns all unapproved ecol_va_memo_txns as @ecol_va_memo_txns when approval_status is passed" do
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn, :approval_status => 'U')
      get :index, :approval_status => 'U'
      assigns(:records).should eq([ecol_va_memo_txn])
    end
  end
    
  describe "POST create" do
    describe "with valid params" do
      it "creates a new ecol_va_memo_txn" do
        params = Factory.attributes_for(:ecol_va_memo_txn)
        expect {
          post :create, {:ecol_va_memo_txn => params}
        }.to change(EcolVaMemoTxn.unscoped, :count).by(1)
        flash[:alert].should  match(/Record successfully created and is pending for approval/)
        response.should be_redirect
      end

      it "assigns a newly created ecol_va_memo_txn as @ecol_va_memo_txn" do
        params = Factory.attributes_for(:ecol_va_memo_txn)
        post :create, {:ecol_va_memo_txn => params}
        assigns(:ecol_va_memo_txn).should be_a(EcolVaMemoTxn)
        assigns(:ecol_va_memo_txn).should be_persisted
      end

      it "redirects to the created ecol_va_memo_txn" do
        params = Factory.attributes_for(:ecol_va_memo_txn)
        post :create, {:ecol_va_memo_txn => params}
        response.should redirect_to(EcolVaMemoTxn.unscoped.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved ecol_va_memo_txn as @ecol_va_memo_txn" do
        params = Factory.attributes_for(:ecol_va_memo_txn)
        params[:reference_no] = nil
        expect {
          post :create, {:ecol_va_memo_txn => params}
        }.to change(EcolVaMemoTxn, :count).by(0)
        assigns(:ecol_va_memo_txn).should be_a(EcolVaMemoTxn)
        assigns(:ecol_va_memo_txn).should_not be_persisted
      end

      it "re-renders the 'new' template when show_errors is true" do
        params = Factory.attributes_for(:ecol_va_memo_txn)
        params[:reference_no] = nil
        post :create, {:ecol_va_memo_txn => params}
        response.should render_template("new")
      end
    end
  end
  
  describe "PUT approve" do
    it "(edit) unapproved record can be approved and old approved record will be updated" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      ecol_va_memo_txn1 = Factory(:ecol_va_memo_txn, :approval_status => 'A')
      ecol_va_memo_txn2 = Factory(:ecol_va_memo_txn, :approval_status => 'U', :account_no => "2425", :approved_version => ecol_va_memo_txn1.lock_version, :approved_id => ecol_va_memo_txn1.id, :created_by => 666)
      # the following line is required for reload to get triggered (TODO)
      ecol_va_memo_txn1.approval_status.should == 'A'
      UnapprovedRecord.count.should == 1
      put :approve, {:id => ecol_va_memo_txn2.id}
      UnapprovedRecord.count.should == 0
      ecol_va_memo_txn1.reload
      ecol_va_memo_txn1.account_no.should == '2425'
      ecol_va_memo_txn1.updated_by.should == "666"
      UnapprovedRecord.find_by_id(ecol_va_memo_txn2.id).should be_nil
    end
  end
  
  describe "destroy" do
    it "should destroy the ecol_va_memo_txn when created_user = current_user" do 
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn, :created_by => @user.id)
      UnapprovedRecord.count.should == 1
      delete :destroy, {:id => ecol_va_memo_txn.id}
      EcolVaMemoTxn.unscoped.find_by_id(ecol_va_memo_txn.id).should be_nil
      UnapprovedRecord.count.should == 0
    end
    
    it "should not destroy the ecol_va_memo_txn when created_user != current_user" do 
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn, :created_by => 5)
      delete :destroy, {:id => ecol_va_memo_txn.id}
      flash[:alert].should  match(/You cannot delete this record!/)
      EcolVaMemoTxn.unscoped.find_by_id(ecol_va_memo_txn.id).should_not be_nil
    end

    it "should not destroy the ecol_va_memo_txn when approval_status = 'A'" do 
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn, :approval_status => "A")
      delete :destroy, {:id => ecol_va_memo_txn.id}
      flash[:alert].should  match(/You cannot delete this record!/)
      EcolVaMemoTxn.unscoped.find_by_id(ecol_va_memo_txn.id).should_not be_nil
    end
  end
end
