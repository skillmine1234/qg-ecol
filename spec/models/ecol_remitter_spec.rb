require 'spec_helper'

describe EcolRemitter do
  include HelperMethods
  
  before(:each) do
    mock_ldap
  end

  context 'association' do
    it { should belong_to(:created_user) }
    it { should belong_to(:updated_user) }
    it { should have_one(:unapproved_record_entry) }
    it { should belong_to(:approved_record) }
  end
  
  context 'validation' do
    [:customer_code, :remitter_code, :rmtr_name, :due_date, :invoice_amt].each do |att|
      it { should validate_presence_of(att) }
    end
    
    [:invoice_amt, :invoice_amt_tol_pct, :min_credit_amt, :max_credit_amt, :due_date_tol_days].each do |att|
      it { should validate_numericality_of(att) }
    end

    [:invoice_amt, :min_credit_amt, :max_credit_amt].each do |att|
      it { should allow_value(1.23).for(att) }
      it { should allow_value(1.2).for(att) }
      it { should_not allow_value(1.234).for(att) }
    end

    context "uniqueness" do
      it do 
        ecol_remitter = Factory(:ecol_remitter, :approval_status => 'A', :customer_subcode => "", :customer_subcode_email => "", :customer_subcode_mobile => "")
        should validate_uniqueness_of(:customer_code).scoped_to(:remitter_code, :invoice_no, :approval_status)
      end
    
      it do 
        ecol_remitter = Factory(:ecol_remitter, :approval_status => 'A', :invoice_no => "")
        should validate_uniqueness_of(:customer_code).scoped_to(:remitter_code, :customer_subcode, :approval_status)
      end

      it do 
        ecol_remitter = Factory(:ecol_remitter, :approval_status => 'A', :customer_subcode => "", :customer_subcode_email => "", :customer_subcode_mobile => "", :invoice_no => "")
        should validate_uniqueness_of(:customer_code).scoped_to(:remitter_code, :approval_status)
      end

      it do 
        ecol_remitter = Factory(:ecol_remitter, :approval_status => 'A')
        should validate_uniqueness_of(:customer_code).scoped_to(:remitter_code, :customer_subcode, :invoice_no, :approval_status)
      end
    end

    it do 
      ecol_remitter = Factory(:ecol_remitter, :credit_acct_no => '1234567890')
      should validate_length_of(:credit_acct_no).is_at_least(10).is_at_most(25)
    end
    
    it "should validate_unapproved_record" do 
      ecol_remitter1 = Factory(:ecol_remitter,:approval_status => 'A')
      ecol_remitter2 = Factory(:ecol_remitter, :approved_id => ecol_remitter1.id)
      ecol_remitter1.should_not be_valid
      ecol_remitter1.errors_on(:base).should == ["Unapproved Record Already Exists for this record"]
    end
  end
  
  context 'fields format' do
    it 'should allow valid format' do
      [:customer_subcode, :remitter_code, :rmtr_acct_no, :invoice_no].each do |att|
        should allow_value('aaAAbbBB00').for(att)
        should allow_value('AAABBBC090').for(att)
        should allow_value('aaa0000bn').for(att)
        should allow_value('0123456789').for(att)
        should allow_value('AAAAAAAAAA').for(att)
      end
    end
    
    it 'should not allow invalid format' do
      ecol_remitter = Factory.build(:ecol_remitter, :customer_subcode => '#$%jhdf', :remitter_code => '.09jnj823',
      :rmtr_acct_no => '134\ndsfdsg', :invoice_no => '&dbsdh^')
      ecol_remitter.save == false 
      [:customer_subcode, :remitter_code, :rmtr_acct_no, :invoice_no].each do |att|
        ecol_remitter.errors_on(att).should == ['Invalid format, expected format is : {[a-z|A-Z|0-9]}']
      end
    end
  end
  
  context "credit account no format" do 
    it "should allow valid format" do
      should allow_value('1234567890').for(:credit_acct_no)
    end 

    it "should not allow invalid format" do
      should_not allow_value('Absdjhsd').for(:credit_acct_no)
      should_not allow_value('@AbcCo').for(:credit_acct_no)
      should_not allow_value('/ab0QWER').for(:credit_acct_no)
    end 
  end
  
  context "check_email_address" do 
    it "should validate email address" do 
      ecol_remitter = Factory.build(:ecol_remitter, :customer_subcode_email => 'ASJD', :rmtr_email => '!d2@8765')
      ecol_remitter.should_not be_valid
      ecol_remitter.errors_on("customer_subcode_email").should == ["is invalid"]
      ecol_remitter.errors_on("rmtr_email").should == ["is invalid"]
      ecol_customer = Factory(:ecol_customer, :code => 'qwerty10', :approval_status => 'A')
      ecol_remitter = Factory.build(:ecol_remitter, :customer_code => 'QWERTY10', :customer_subcode_email  => "foo@ruby.com", :rmtr_email => "foo@ruby.com")
      ecol_remitter.should be_valid
    end
  end
  
  context 'mobile number format' do
    it 'should allow valid format' do
      ecol_remitter = Factory.build(:ecol_remitter, :customer_subcode => '1213')
      [:customer_subcode_mobile, :rmtr_mobile].each do |att|
        ecol_remitter.should allow_value('9876543210').for(att)
      end
    end
    
    it 'should not allow invalid format' do
      ecol_remitter = Factory.build(:ecol_remitter, :customer_subcode_mobile => 'ASJD\98709', :rmtr_mobile => '-0!uhbd876')
      [:customer_subcode_mobile, :rmtr_mobile].each do |att|
        ecol_remitter.errors_on(att).should == ['Invalid format, expected format is : {[0-9]}']
      end
    end
  end
  
  context 'remitter name & address format' do
    it 'should allow valid format' do
      [:rmtr_name, :rmtr_address].each do |att|
        should allow_value('Abcd(09),op').for(att)
        should allow_value('Abcde:fgh').for(att)
        should allow_value('Abcd-op?').for(att)
        should allow_value('Abcd op jk').for(att)
      end
    end

    it 'should not allow invalid format' do
      ecol_remitter = Factory.build(:ecol_remitter, :rmtr_name => 'Anjkds**', :rmtr_address => '@ajdjh&NK#')
      ecol_remitter.save == false
      [:rmtr_name, :rmtr_address].each do |att|
        ecol_remitter.errors_on(att).should == ['Invalid format, expected format is : {[a-z|A-Z|0-9|\:|\/|\-|\?|\+|\(|\)|\.|\,\s]}']
      end
    end
  end
  
  context 'if_customer_subcode_is_nil' do
    it 'should perform validation if customer_subcode is nil' do
      ecol_remitter = Factory.build(:ecol_remitter, :customer_subcode => nil, :customer_subcode_mobile => '9876543210', :customer_subcode_email => 'a@b.com')
      ecol_remitter.save == false
      ecol_remitter.errors[:customer_subcode_email].should == ['should be empty when customer_subcode is empty']
      ecol_remitter.errors[:customer_subcode_mobile].should == ['should be empty when customer_subcode is empty']
    end
  end
  
  context "length" do
    it "should validate the length of the input if length constraint is present" do 
      udf_attribute = Factory(:udf_attribute, :attribute_name => 'udf4', :label_text => 'Udf4', :control_type => 'TextBox', :data_type => 'String', :length => 3, :is_enabled => 'Y',:approval_status => 'A')
      ecol_customer = Factory(:ecol_customer, :code => 'qwerty10')
      ecol_remitter = Factory.build(:ecol_remitter, :customer_code => 'qwerty10', :udf4 => '1234')
      ecol_remitter.should_not be_valid
      ecol_remitter.errors_on(:udf4).should == ["should be of 3 characters"]
      ecol_remitter = Factory.build(:ecol_remitter, :udf4 => ' ')
      ecol_remitter.errors_on(:udf4).should == []
    end
  end

  context "minimum length" do
    it "should validate the length of the input if minimum length constraint is present" do
      udf_attribute = Factory(:udf_attribute, :attribute_name => 'udf4', :label_text => 'Udf4', :control_type => 'TextBox', :data_type => 'String', :min_length => 3, :is_enabled => 'Y',:approval_status => 'A')
      ecol_customer = Factory(:ecol_customer, :code => 'qwerty10')
      ecol_remitter = Factory.build(:ecol_remitter, :customer_code => 'qwerty10', :udf4 => '12')
      ecol_remitter.should_not be_valid
      ecol_remitter.errors_on(:udf4).should == ["is too short (minimum is 3 characters)"]
      ecol_remitter = Factory.build(:ecol_remitter, :udf4 => ' ')
      ecol_remitter.errors_on(:udf4).should == []
    end
  end

  context "maximum length" do
    it "should validate the length of the input if maximum length constraint is present" do
      udf_attribute = Factory(:udf_attribute, :attribute_name => 'udf4', :label_text => 'Udf4', :control_type => 'TextBox', :data_type => 'String', :max_length => 3, :is_enabled => 'Y',:approval_status => 'A')
      ecol_customer = Factory(:ecol_customer, :code => 'qwerty10')
      ecol_remitter = Factory.build(:ecol_remitter, :customer_code => 'qwerty10', :udf4 => '12678')
      ecol_remitter.should_not be_valid
      ecol_remitter.errors_on(:udf4).should == ["is too long (maximum is 3 characters)"]
      ecol_remitter = Factory.build(:ecol_remitter, :udf4 => ' ')
      ecol_remitter.errors_on(:udf4).should == []
    end
  end

  context "minimum value" do
    it "should validate the value of the input if minimum value constraint is present" do
      udf_attribute = Factory(:udf_attribute, :attribute_name => 'udf4', :label_text => 'Udf4', :control_type => 'TextBox', :data_type => 'Numeric', :min_value => 30, :is_enabled => 'Y',:approval_status => 'A')
      ecol_customer = Factory(:ecol_customer, :code => 'qwerty10')
      ecol_remitter = Factory.build(:ecol_remitter, :customer_code => 'qwerty10', :udf4 => "20")
      ecol_remitter.should_not be_valid
      ecol_remitter.errors_on(:udf4).should == ["is less than 30"]
      ecol_remitter = Factory.build(:ecol_remitter, :udf4 => " ")
      ecol_remitter.errors_on(:udf4).should == []
    end
  end

  context "maximum value" do
    it "should validate the value of the input if maximum value constraint is present" do
      udf_attribute = Factory(:udf_attribute, :attribute_name => 'udf4', :label_text => 'Udf4', :control_type => 'TextBox', :data_type => 'Numeric', :max_value => 30, :is_enabled => 'Y',:approval_status => 'A')
      ecol_customer = Factory(:ecol_customer, :code => 'qwerty10')
      ecol_remitter = Factory.build(:ecol_remitter, :customer_code => 'qwerty10', :udf4 => "12678")
      ecol_remitter.should_not be_valid
      ecol_remitter.errors_on(:udf4).should == ["is more than 30"]
      ecol_remitter = Factory.build(:ecol_remitter, :udf4 => " ")
      ecol_remitter.errors_on(:udf4).should == []
    end
  end

  context "mandatory" do
    it "should validate the value of the input if maximum value constraint is present" do
      udf_attribute = Factory(:udf_attribute, :attribute_name => 'udf4', :label_text => 'Udf4', :control_type => 'TextBox', :data_type => 'Numeric', :is_mandatory => 'Y', :is_enabled => 'Y',:approval_status => 'A')
      ecol_customer = Factory(:ecol_customer, :code => 'qwerty10')
      ecol_remitter = Factory.build(:ecol_remitter, :customer_code => 'qwerty10', :udf4 => nil)
      ecol_remitter.should_not be_valid
      ecol_remitter.errors_on(:udf4).should == ["is required"]
    end
  end
  
  context "customer_code_should_exist" do
    it "should check if the customer code exists" do
      ecol_customer = Factory(:ecol_customer, :code => 'CUST0009')
      ecol_remitter = Factory.build(:ecol_remitter, :customer_code => 'CUST0000')
      ecol_remitter.save == true
      ecol_remitter = Factory.build(:ecol_remitter, :customer_code => 'CUST9999')
      ecol_remitter.save == false
      ecol_remitter.errors_on(:customer_code) == ["Invalid Customer"]
    end
  end
  
  context "default_scope" do 
    it "should only return 'A' records by default" do 
      ecol_remitter1 = Factory(:ecol_remitter, :approval_status => 'A') 
      ecol_remitter2 = Factory(:ecol_remitter)
      EcolRemitter.all.should == [ecol_remitter1]
      ecol_remitter2.approval_status = 'A'
      ecol_remitter2.save
      EcolRemitter.all.should == [ecol_remitter1,ecol_remitter2]
    end
  end    

  context "unapproved_record_entrys" do 
    it "oncreate: should create unapproved_record_entry if the approval_status is 'U'" do
      ecol_remitter = Factory(:ecol_remitter)
      ecol_remitter.reload
      ecol_remitter.unapproved_record_entry.should_not be_nil
    end

    it "oncreate: should not create unapproved_record_entry if the approval_status is 'A'" do
      ecol_remitter = Factory(:ecol_remitter, :approval_status => 'A')
      ecol_remitter.unapproved_record_entry.should be_nil
    end

    it "onupdate: should not remove unapproved_record_entry if approval_status did not change from U to A" do
      ecol_remitter = Factory(:ecol_remitter)
      ecol_remitter.reload
      ecol_remitter.unapproved_record_entry.should_not be_nil
      record = ecol_remitter.unapproved_record_entry
      # we are editing the U record, before it is approved
      ecol_remitter.rmtr_name = 'Fooo'
      ecol_remitter.save
      ecol_remitter.reload
      ecol_remitter.unapproved_record_entry.should == record
    end
    
    it "onupdate: should remove unapproved_record_entry if the approval_status changed from 'U' to 'A' (approval)" do
      ecol_remitter = Factory(:ecol_remitter)
      ecol_remitter.reload
      ecol_remitter.unapproved_record_entry.should_not be_nil
      # the approval process changes the approval_status from U to A for a newly edited record
      ecol_remitter.approval_status = 'A'
      ecol_remitter.save
      ecol_remitter.reload
      ecol_remitter.unapproved_record_entry.should be_nil
    end
    
    it "ondestroy: should remove unapproved_record_entry if the record with approval_status 'U' was destroyed (approval) " do
      ecol_remitter = Factory(:ecol_remitter)
      ecol_remitter.reload
      ecol_remitter.unapproved_record_entry.should_not be_nil
      record = ecol_remitter.unapproved_record_entry
      # the approval process destroys the U record, for an edited record 
      ecol_remitter.destroy
      UnapprovedRecord.find_by_id(record.id).should be_nil
    end
  end

  context "approve" do 
    it "should approve unapproved_record" do 
      ecol_remitter = Factory(:ecol_remitter, :approval_status => 'U')
      ecol_remitter.approve.save.should == true
      ecol_remitter.approval_status.should == 'A'
    end

    it "should return error when trying to approve unmatched version" do 
      ecol_remitter = Factory(:ecol_remitter, :approval_status => 'A')
      ecol_remitter2 = Factory(:ecol_remitter, :approval_status => 'U', :approved_id => ecol_remitter.id, :approved_version => 6)
      ecol_remitter2.approve.should == "The record version is different from that of the approved version" 
    end
  end

  context "enable_approve_button?" do 
    it "should return true if approval_status is 'U' else false" do 
      ecol_remitter1 = Factory(:ecol_remitter, :approval_status => 'A')
      ecol_remitter2 = Factory(:ecol_remitter, :approval_status => 'U')
      ecol_remitter1.enable_approve_button?.should == false
      ecol_remitter2.enable_approve_button?.should == true
    end
  end
  
  context "to_upcase" do
    it "should convert values to upcase before save" do
      ecol_customer = Factory(:ecol_customer, :code => "as89nnmm", :approval_status => "A")
      ecol_remitter = Factory(:ecol_remitter, :customer_code => "AS89NNMM", :remitter_code => "qwerty10", :invoice_no => "abcdef")
      ecol_remitter.customer_code.should == "AS89NNMM"
      ecol_remitter.remitter_code.should == "QWERTY10"
      ecol_remitter.invoice_no.should == "ABCDEF"
    end
  end
end
