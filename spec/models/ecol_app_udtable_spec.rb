require 'spec_helper'

describe EcolAppUdtable do

  context 'association' do
    it { should belong_to(:created_user) }
    it { should belong_to(:updated_user) }
    it { should belong_to(:ecol_app) }
  end

  context "validation" do
    [:app_code, :udf1].each do |att|
      it { should validate_presence_of(att) }
    end

    it do
      ecol_app = Factory(:ecol_app, unique_udfs_cnt: 1, udf1_name: 'udf1', udf1_type: 'text', approval_status: 'A')
      ecol_app_udtable = Factory(:ecol_app_udtable, app_code: ecol_app.app_code, :udf1 => 'MyString', approval_status: 'A')
      should validate_uniqueness_of(:app_code).scoped_to(:udf1, :approval_status)
    end
  end

  context "default_scope" do 
    it "should only return 'A' records by default" do 
      ecol_app_udtable1 = Factory(:ecol_app_udtable, :approval_status => 'A') 
      ecol_app_udtable2 = Factory(:ecol_app_udtable, :udf1 => 'MyString')
      EcolAppUdtable.all.should == [ecol_app_udtable1]
      ecol_app_udtable2.approval_status = 'A'
      ecol_app_udtable2.save
      EcolAppUdtable.all.should == [ecol_app_udtable1,ecol_app_udtable2]
    end
  end

  context "unapproved_records" do 
    it "oncreate: should create unapproved_record if the approval_status is 'U'" do
      ecol_app_udtable = Factory(:ecol_app_udtable)
      ecol_app_udtable.reload
      ecol_app_udtable.unapproved_record_entry.should_not be_nil
    end

    it "oncreate: should not create unapproved_record if the approval_status is 'A'" do
      ecol_app_udtable = Factory(:ecol_app_udtable, :approval_status => 'A')
      ecol_app_udtable.unapproved_record_entry.should be_nil
    end

    it "onupdate: should not remove unapproved_record if approval_status did not change from U to A" do
      ecol_app_udtable = Factory(:ecol_app_udtable)
      ecol_app_udtable.reload
      ecol_app_udtable.unapproved_record_entry.should_not be_nil
      record = ecol_app_udtable.unapproved_record_entry
      # we are editing the U record, before it is approved
      ecol_app_udtable.udf1 = 'Foo123'
      ecol_app_udtable.save
      ecol_app_udtable.reload
      ecol_app_udtable.unapproved_record_entry.should == record
    end

    it "onupdate: should remove unapproved_record if the approval_status changed from 'U' to 'A' (approval)" do
      ecol_app_udtable = Factory(:ecol_app_udtable)
      ecol_app_udtable.reload
      ecol_app_udtable.unapproved_record_entry.should_not be_nil
      # the approval process changes the approval_status from U to A for a newly edited record
      ecol_app_udtable.approval_status = 'A'
      ecol_app_udtable.save
      ecol_app_udtable.reload
      ecol_app_udtable.unapproved_record_entry.should be_nil
    end

    it "ondestroy: should remove unapproved_record if the record with approval_status 'U' was destroyed (approval) " do
      ecol_app_udtable = Factory(:ecol_app_udtable)
      ecol_app_udtable.reload
      ecol_app_udtable.unapproved_record_entry.should_not be_nil
      record = ecol_app_udtable.unapproved_record_entry
      # the approval process destroys the U record, for an edited record 
      ecol_app_udtable.destroy
      UnapprovedRecord.find_by_id(record.id).should be_nil
    end
  end

  context "approve" do 
    it "should approve unapproved_record" do 
      ecol_app_udtable = Factory(:ecol_app_udtable, :approval_status => 'U')
      ecol_app_udtable.approve.save.should == true
      ecol_app_udtable.approval_status.should == 'A'
    end

    it "should return error when trying to approve unmatched version" do 
      ecol_app_udtable = Factory(:ecol_app_udtable, :approval_status => 'A')
      ecol_app_udtable1 = Factory(:ecol_app_udtable, :approval_status => 'U', :approved_id => ecol_app_udtable.id, :approved_version => 6)
      ecol_app_udtable1.approve.should == "The record version is different from that of the approved version" 
    end
  end

  context "enable_approve_button?" do 
    it "should return true if approval_status is 'U' else false" do 
      ecol_app_udtable1 = Factory(:ecol_app_udtable, :approval_status => 'A')
      ecol_app_udtable2 = Factory(:ecol_app_udtable, :approval_status => 'U')
      ecol_app_udtable1.enable_approve_button?.should == false
      ecol_app_udtable2.enable_approve_button?.should == true
    end
  end
  
  context "udfs_should_be_correct" do
    it "should give error when the value is nil" do
      ecol_app_udtable = Factory.build(:ecol_app_udtable, udf1: nil, approval_status: 'A')
      ecol_app_udtable.save.should == false
      ecol_app_udtable.errors_on(:base).should == ["udf1 can't be blank"]
    end
    it "should give error when the type is date and value is not a valid date" do
      ecol_app = Factory(:ecol_app, unique_udfs_cnt: 1, udf1_name: 'udf1', udf1_type: 'date', approval_status: 'A')
      ecol_app_udtable = Factory.build(:ecol_app_udtable, app_code: ecol_app.app_code, udf1: '2015-24-24', approval_status: 'A')
      ecol_app_udtable.save.should == false
      ecol_app_udtable.errors_on(:base).should == ["udf1 is not a date"]
    end
    it "should give error when the type is text and value is too long" do
      ecol_app_udtable = Factory.build(:ecol_app_udtable, udf1: '1232301293819028312uw1288127312318923012381923019231uw192u8319238120wi1293812312wi1290', approval_status: 'A')
      ecol_app_udtable.save.should == false
      ecol_app_udtable.errors_on(:base).should == ["udf1 is too long, maximum is 50 charactres"]
    end
    it "should give error when the type is text and value includes special characters" do
      ecol_app_udtable = Factory.build(:ecol_app_udtable, udf1: '!@123!@#', approval_status: 'A')
      ecol_app_udtable.save.should == false
      ecol_app_udtable.errors_on(:base).should == ["udf1 should not include special characters"]
    end    
    it "should not give any error when the udfs are correct" do
      ecol_app = Factory(:ecol_app, unique_udfs_cnt: 1, udf1_name: 'udf1', udf1_type: 'text', approval_status: 'A')
      ecol_app_udtable = Factory.build(:ecol_app_udtable, app_code: ecol_app.app_code, udf1: 'name', approval_status: 'A')
      ecol_app_udtable.save.should == true
    end
  end
  
  context "sanitize_udfs" do
    it "should sanitize udfs" do
      ecol_app = Factory(:ecol_app, unique_udfs_cnt: 1, udf1_name: 'udf1', udf1_type: 'text', approval_status: 'A')
      ecol_app_udtable = Factory(:ecol_app_udtable, app_code: ecol_app.app_code, udf1: 'abc', udf2: nil, udf3: 'a', approval_status: 'A')
      ecol_app_udtable.udf1.should_not be_nil
      ecol_app_udtable.udf2.should be_nil
      ecol_app_udtable.udf3.should be_nil
      ecol_app_udtable.udf4.should be_nil
      ecol_app_udtable.udf5.should be_nil
    end
  end
end
