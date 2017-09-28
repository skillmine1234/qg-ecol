require 'spec_helper'
require "cancan_matcher"

describe EcolIncomingRecordsController do

  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
  end

  describe "GET index" do
    it "assigns all ecol_incoming_record as @ecol_incoming_record" do
      ecol_incoming_record = Factory(:ecol_incoming_record)
      get :index, :file_name => ecol_incoming_record.file_name, :status => 'FAILED'
      assigns(:records).should eq([ecol_incoming_record])
    end
  end

  describe "GET show" do
    it "assigns one ecol_incoming_record as @ecol_incoming_record" do
      ecol_incoming_record = Factory(:ecol_incoming_record)
      get :show, :id => ecol_incoming_record.id
      assigns(:ecol_record).should eq(ecol_incoming_record)
    end
  end

  describe "GET audit_logs" do
    it "assigns the requested ecol_incoming_record as @ecol_incoming_record" do
      ecol_incoming_record = Factory(:ecol_incoming_record)
      get :audit_logs, {:id => ecol_incoming_record.incoming_file_record_id, :version_id => 0}
      assigns(:record).should eq(ecol_incoming_record.incoming_file_record)
      assigns(:audit).should eq(ecol_incoming_record.incoming_file_record.audits.first)
      get :audit_logs, {:id => 12345, :version_id => "i"}
      assigns(:record).should eq(nil)
      assigns(:audit).should eq(nil)
    end
  end

  describe "GET incoming_file_summary" do
    it "assigns one ecol_incoming_file as @summary" do
      ecol_incoming_file = Factory(:ecol_incoming_file)
      get :incoming_file_summary, :file_name => ecol_incoming_file.file_name
      assigns(:summary).should eq(ecol_incoming_file)
    end
  end
end