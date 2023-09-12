require 'spec_helper'

describe EcolRule do
  context 'association' do
    it { should belong_to(:created_user) }
    it { should belong_to(:updated_user) }
    it { should have_one(:unapproved_record_entry) }
    it { should belong_to(:approved_record) }
  end
  
  context 'validation' do
    [:ifsc, :cod_acct_no, :stl_gl_inward, :neft_sender_ifsc, :customer_id].each do |att|
      it { should validate_presence_of(att) }
    end
    
    it "should validate_unapproved_record" do 
      ecol_rule1 = Factory(:ecol_rule,:approval_status => 'A')
      ecol_rule2 = Factory(:ecol_rule, :approved_id => ecol_rule1.id)
      ecol_rule1.should_not be_valid
      ecol_rule1.errors_on(:base).should == ["Unapproved Record Already Exists for this record"]
    end
  end
  
  context "fields format" do
    it "should allow valid format" do 
      [:cod_acct_no, :return_account_no, :stl_gl_inward, :customer_id].each do |att|
        should allow_value('aaAAbbBB00').for(att)
        should allow_value('AAABBBC090').for(att)
        should allow_value('aaa0000bn').for(att)
        should allow_value('0123456789').for(att)
        should allow_value('AAAAAAAAAA').for(att)
      end
    end

    it "should not allow invalid format" do 
      ecol_rule = Factory.build(:ecol_rule, :cod_acct_no => '-1dfghhhhh', :return_account_no => 'ABC-1234', :stl_gl_inward => '@acddsfdfd', 
      :customer_id => '@,.9023jsf')
      ecol_rule.save == false
      [:cod_acct_no, :return_account_no, :stl_gl_inward, :customer_id].each do |att|
        ecol_rule.errors_on(att).should == ["Invalid format, expected format is : {[a-z|A-Z|0-9]}"]
      end
    end
  end
  
  context "ifsc format" do 
    [:ifsc, :neft_sender_ifsc].each do |att|
      it "should allow valid format" do
        should allow_value('ABCD0QWERTY').for(att)
      end 
    end
    
    it "should not allow invalid format" do
      ecol_rule = Factory.build(:ecol_rule, :ifsc => 'abcd0QWERTY')
      ecol_rule.errors_on(:ifsc).should == ["Invalid format, expected format is : {[A-Z]{4}[0][A-Z|0-9]{6}}"]
      ecol_rule = Factory.build(:ecol_rule, :ifsc => 'abcdQWERTY')
      ecol_rule.errors_on(:ifsc).should == ["Invalid format, expected format is : {[A-Z]{4}[0][A-Z|0-9]{6}}"]
      ecol_rule = Factory.build(:ecol_rule, :ifsc => 'ab0QWER')
      ecol_rule.errors_on(:ifsc).should == ["Invalid format, expected format is : {[A-Z]{4}[0][A-Z|0-9]{6}}"]
    end 
  end

  context "default_scope" do 
    it "should only return 'A' records by default" do 
      ecol_rule1 = Factory(:ecol_rule, :approval_status => 'A') 
      ecol_rule2 = Factory(:ecol_rule)
      EcolRule.all.should == [ecol_rule1]
      ecol_rule2.approval_status = 'A'
      ecol_rule2.save
      EcolRule.all.should == [ecol_rule1,ecol_rule2]
    end
  end    

  context "create_unapproved_record_entrys" do 
    it "should create unapproved_record_entry if the approval_status is 'U' and there is no previous record" do
      ecol_rule = Factory(:ecol_rule)
      ecol_rule.reload
      ecol_rule.unapproved_record_entry.should_not be_nil
      record = ecol_rule.unapproved_record_entry
      ecol_rule.save
      ecol_rule.unapproved_record_entry.should == record
    end

    it "should not create unapproved_record_entry if the approval_status is 'A'" do
      ecol_rule = Factory(:ecol_rule, :approval_status => 'A')
      ecol_rule.unapproved_record_entry.should be_nil
    end
  end  

  context "unapproved_record_entrys" do 
    it "oncreate: should create unapproved_record_entry if the approval_status is 'U'" do
      ecol_rule = Factory(:ecol_rule)
      ecol_rule.reload
      ecol_rule.unapproved_record_entry.should_not be_nil
    end

    it "oncreate: should not create unapproved_record_entry if the approval_status is 'A'" do
      ecol_rule = Factory(:ecol_rule, :approval_status => 'A')
      ecol_rule.unapproved_record_entry.should be_nil
    end

    it "onupdate: should not remove unapproved_record_entry if approval_status did not change from U to A" do
      ecol_rule = Factory(:ecol_rule)
      ecol_rule.reload
      ecol_rule.unapproved_record_entry.should_not be_nil
      record = ecol_rule.unapproved_record_entry
      # we are editing the U record, before it is approved
      ecol_rule.cod_acct_no = 'Fooo'
      ecol_rule.save
      ecol_rule.reload
      ecol_rule.unapproved_record_entry.should == record
    end
    
    it "onupdate: should remove unapproved_record_entry if the approval_status changed from 'U' to 'A' (approval)" do
      ecol_rule = Factory(:ecol_rule)
      ecol_rule.reload
      ecol_rule.unapproved_record_entry.should_not be_nil
      # the approval process changes the approval_status from U to A for a newly edited record
      ecol_rule.approval_status = 'A'
      ecol_rule.save
      ecol_rule.reload
      ecol_rule.unapproved_record_entry.should be_nil
    end
    
    it "ondestroy: should remove unapproved_record_entry if the record with approval_status 'U' was destroyed (approval) " do
      ecol_rule = Factory(:ecol_rule)
      ecol_rule.reload
      ecol_rule.unapproved_record_entry.should_not be_nil
      record = ecol_rule.unapproved_record_entry
      # the approval process destroys the U record, for an edited record 
      ecol_rule.destroy
      UnapprovedRecord.find_by_id(record.id).should be_nil
    end
  end

  context "approve" do 
    it "should approve unapproved_record" do 
      ecol_rule = Factory(:ecol_rule, :approval_status => 'U')
      ecol_rule.approve.save.should == true
      ecol_rule.approval_status.should == 'A'
    end

    it "should return error when trying to approve unmatched version" do 
      ecol_rule = Factory(:ecol_rule, :approval_status => 'A')
      ecol_rule2 = Factory(:ecol_rule, :approval_status => 'U', :approved_id => ecol_rule.id, :approved_version => 6)
      ecol_rule2.approve.should == "The record version is different from that of the approved version" 
    end
  end

  context "enable_approve_button?" do 
    it "should return true if approval_status is 'U' else false" do 
      ecol_rule1 = Factory(:ecol_rule, :approval_status => 'A')
      ecol_rule2 = Factory(:ecol_rule, :approval_status => 'U')
      ecol_rule1.enable_approve_button?.should == false
      ecol_rule2.enable_approve_button?.should == true
    end
  end
end
