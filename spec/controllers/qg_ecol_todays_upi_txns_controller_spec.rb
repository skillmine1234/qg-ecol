require 'spec_helper'

describe QgEcolTodaysUpiTxnsController do
  include HelperMethods

  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
    request.env["CONFIG_ENVIRONMENT"] = "test"
  end


  describe "GET index" do
    it "assigns all qg_ecol_todays_upi_txns as @qg_ecol_todays_upi_txns" do
      qg_ecol_todays_upi_txn = Factory(:qg_ecol_todays_upi_txn)
      get :index
      assigns(:qg_ecol_todays_upi_txns).should eq([qg_ecol_todays_upi_txn])
    end
  end

  describe "GET show" do
    it "assigns the requested qg_ecol_todays_upi_txn as @qg_ecol_todays_upi_txn" do
      qg_ecol_todays_upi_txn = Factory(:qg_ecol_todays_upi_txn)
      get :show, {:id => qg_ecol_todays_upi_txn.id}
      assigns(:qg_ecol_todays_upi_txn).should eq(qg_ecol_todays_upi_txn)
    end
  end

  describe "GET new" do
    it "assigns a new qg_ecol_todays_upi_txn as @qg_ecol_todays_upi_txn" do
      get :new
      assigns(:qg_ecol_todays_upi_txn).should be_a_new(QgEcolTodaysUpiTxn)
    end
  end

  describe "GET edit" do
    it "assigns the requested qg_ecol_todays_upi_txn as @qg_ecol_todays_upi_txn" do
      @qg_ecol_todays_upi_txn = Factory(:qg_ecol_todays_upi_txn)
      get :edit, {:id => @qg_ecol_todays_upi_txn.id}
      assigns(:qg_ecol_todays_upi_txn).should eq(@qg_ecol_todays_upi_txn)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new qg_ecol_todays_upi_txn" do
        params = Factory.attributes_for(:qg_ecol_todays_upi_txn)
        expect {
          post :create, {:qg_ecol_todays_upi_txn => params}
        }.to change(QgEcolTodaysUpiTxn.all, :count).by(1)
        flash[:alert].should  match(/UPI Transaction successfully created/)
        response.should be_redirect
      end

      it "assigns a newly created qg_ecol_todays_upi_txn as @qg_ecol_todays_upi_txn" do
        params = Factory.attributes_for(:qg_ecol_todays_upi_txn)
        post :create, {:qg_ecol_todays_upi_txn => params}
        assigns(:qg_ecol_todays_upi_txn).should be_a(QgEcolTodaysUpiTxn)
        assigns(:qg_ecol_todays_upi_txn).should be_persisted
      end

      it "redirects to the qg_ecol_todays_upi_txns list" do
        params = Factory.attributes_for(:qg_ecol_todays_upi_txn)
        post :create, {:qg_ecol_todays_upi_txn => params}
        response.should redirect_to(qg_ecol_todays_upi_txns_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved qg_ecol_todays_upi_txn as @qg_ecol_todays_upi_txn" do
        params = Factory.attributes_for(:qg_ecol_todays_upi_txn)
        params[:transfer_unique_no] = nil
        expect {
          post :create, {:qg_ecol_todays_upi_txn => params}
        }.to change(QgEcolTodaysUpiTxn.all, :count).by(0)
        assigns(:qg_ecol_todays_upi_txn).should be_a(QgEcolTodaysUpiTxn)
        assigns(:qg_ecol_todays_upi_txn).should_not be_persisted
      end

      it "re-renders the 'new' template when show_errors is true" do
        params = Factory.attributes_for(:qg_ecol_todays_upi_txn)
        params[:transfer_unique_no] = nil
        post :create, {:qg_ecol_todays_upi_txn => params}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested qg_ecol_todays_upi_txn" do
        qg_ecol_todays_upi_txn = Factory(:qg_ecol_todays_upi_txn, :rmtr_ref => "ABC")
        params = qg_ecol_todays_upi_txn.attributes.slice(*qg_ecol_todays_upi_txn.class.attribute_names)
        params[:rmtr_ref] = "ABC"
        put :update, {:id => qg_ecol_todays_upi_txn.id, :qg_ecol_todays_upi_txn => params}
        qg_ecol_todays_upi_txn.reload
        qg_ecol_todays_upi_txn.rmtr_ref.should == "ABC"
      end

      it "assigns the requested qg_ecol_todays_upi_txn as @qg_ecol_todays_upi_txn" do
        qg_ecol_todays_upi_txn = Factory(:qg_ecol_todays_upi_txn, :rmtr_ref => "ABC")
        params = qg_ecol_todays_upi_txn.attributes.slice(*qg_ecol_todays_upi_txn.class.attribute_names)
        params[:rmtr_ref] = "ABC"
        put :update, {:id => qg_ecol_todays_upi_txn.to_param, :qg_ecol_todays_upi_txn => params}
        assigns(:qg_ecol_todays_upi_txn).should eq(qg_ecol_todays_upi_txn)
      end

      it "redirects to the qg_ecol_todays_upi_txn list" do
        qg_ecol_todays_upi_txn = Factory(:qg_ecol_todays_upi_txn, :rmtr_ref => "ABC")
        params = qg_ecol_todays_upi_txn.attributes.slice(*qg_ecol_todays_upi_txn.class.attribute_names)
        params[:rmtr_ref] = "ABC"
        put :update, {:id => qg_ecol_todays_upi_txn.to_param, :qg_ecol_todays_upi_txn => params}
        response.should redirect_to(qg_ecol_todays_upi_txns_url)
      end
    end
  end

  describe "destroy" do
    it "should destroy the qg_ecol_todays_upi_txn" do 
      qg_ecol_todays_upi_txn = Factory(:qg_ecol_todays_upi_txn)
      expect {delete :destroy, {:id => qg_ecol_todays_upi_txn.id}}.to change(QgEcolTodaysUpiTxn, :count).by(-1)
      QgEcolTodaysUpiTxn.find_by_id(qg_ecol_todays_upi_txn.id).should be_nil
    end

    it "redirects to the qg_ecol_todays_upi_txn list" do
      qg_ecol_todays_upi_txn = Factory(:qg_ecol_todays_upi_txn)
      delete :destroy, {:id => qg_ecol_todays_upi_txn.id}
      response.should redirect_to(qg_ecol_todays_upi_txns_url)
    end
  end

end