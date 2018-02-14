require 'spec_helper'

describe EcolVaMemoTxn do

  context 'association' do
    it { should belong_to(:created_user) }
    it { should belong_to(:updated_user) }
  end

  context "validation" do
    [:reference_no, :account_no, :txn_amount, :txn_type, :customer_code].each do |att|
      it { should validate_presence_of(att) }
    end
    
    it "should validate uniqueness of fields" do
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn, approval_status: 'A')
      should validate_uniqueness_of(:reference_no).scoped_to(:approval_status)
    end
    
    it { should validate_length_of(:account_no).is_at_most(64) }
    it { should validate_length_of(:txn_desc).is_at_most(255) }
    it { should validate_numericality_of(:hold_no) }
    it { should validate_numericality_of(:txn_amount) }
    it { should validate_numericality_of(:hold_amount) }

    context "format" do      
      context "account_no" do
        it "should accept value matching the format" do
          [:account_no].each do |att|
            should allow_value('1234567890').for(att)
          end
        end

        it "should not accept value which does not match the format" do
          [:account_no].each do |att|
            should_not allow_value('ACC@123!').for(att)
            should_not allow_value('acc~@123*^').for(att)
          end
        end
      end
    end
  end

  context "default_scope" do 
    it "should only return 'A' records by default" do 
      ecol_va_memo_txn1 = Factory(:ecol_va_memo_txn, :approval_status => 'A') 
      ecol_va_memo_txn2 = Factory(:ecol_va_memo_txn)
      EcolVaMemoTxn.all.should == [ecol_va_memo_txn1]
      ecol_va_memo_txn2.approval_status = 'A'
      ecol_va_memo_txn2.save
      EcolVaMemoTxn.all.should == [ecol_va_memo_txn1,ecol_va_memo_txn2]
    end
  end    

  context "unapproved_records" do 
    it "oncreate: should create unapproved_record if the approval_status is 'U'" do
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn)
      ecol_va_memo_txn.reload
      ecol_va_memo_txn.unapproved_record_entry.should_not be_nil
    end

    it "oncreate: should not create unapproved_record if the approval_status is 'A'" do
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn, :approval_status => 'A')
      ecol_va_memo_txn.unapproved_record_entry.should be_nil
    end

    it "onupdate: should not remove unapproved_record if approval_status did not change from U to A" do
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn)
      ecol_va_memo_txn.reload
      ecol_va_memo_txn.unapproved_record_entry.should_not be_nil
      record = ecol_va_memo_txn.unapproved_record_entry
      # we are editing the U record, before it is approved
      ecol_va_memo_txn.account_no = '7823641923'
      ecol_va_memo_txn.save
      ecol_va_memo_txn.reload
      ecol_va_memo_txn.unapproved_record_entry.should == record
    end

    it "onupdate: should remove unapproved_record if the approval_status changed from 'U' to 'A' (approval)" do
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn)
      ecol_va_memo_txn.reload
      ecol_va_memo_txn.unapproved_record_entry.should_not be_nil
      # the approval process changes the approval_status from U to A for a newly edited record
      ecol_va_memo_txn.approval_status = 'A'
      ecol_va_memo_txn.save
      ecol_va_memo_txn.reload
      ecol_va_memo_txn.unapproved_record_entry.should be_nil
    end

    it "ondestroy: should remove unapproved_record if the record with approval_status 'U' was destroyed (approval) " do
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn)
      ecol_va_memo_txn.reload
      ecol_va_memo_txn.unapproved_record_entry.should_not be_nil
      record = ecol_va_memo_txn.unapproved_record_entry
      # the approval process destroys the U record, for an edited record 
      ecol_va_memo_txn.destroy
      UnapprovedRecord.find_by_id(record.id).should be_nil
    end
  end

  context "approve" do 
    it "should approve unapproved_record" do 
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn, :approval_status => 'U')
      ecol_va_memo_txn.approve.save.should == true
      ecol_va_memo_txn.approval_status.should == 'A'
    end

    it "should return error when trying to approve unmatched version" do 
      ecol_va_memo_txn = Factory(:ecol_va_memo_txn, :approval_status => 'A')
      ecol_va_memo_txn1 = Factory(:ecol_va_memo_txn, :approval_status => 'U', :approved_id => ecol_va_memo_txn.id, :approved_version => 6)
      ecol_va_memo_txn1.approve.should == "The record version is different from that of the approved version" 
    end
  end

  context "enable_approve_button?" do 
    it "should return true if approval_status is 'U' else false" do 
      ecol_va_memo_txn1 = Factory(:ecol_va_memo_txn, :approval_status => 'A')
      ecol_va_memo_txn2 = Factory(:ecol_va_memo_txn, :approval_status => 'U')
      ecol_va_memo_txn1.enable_approve_button?.should == false
      ecol_va_memo_txn2.enable_approve_button?.should == true
    end
  end
  
  context 'presence_of_ecol_customer' do
    it 'should validate presence of ecol_customer record for ecol_customer_code' do
      ecol_va_memo_txn = Factory.build(:ecol_va_memo_txn, customer_code: '0000')
      ecol_va_memo_txn.save.should == false
      ecol_va_memo_txn.errors_on(:customer_code).should == ['Invalid E-Collect Customer Code']

      ecol_customer = Factory(:ecol_customer, code: '9018', val_method: 'V', approval_status: 'A')
      ecol_va_memo_txn = Factory.build(:ecol_va_memo_txn, customer_code: '9018')
      ecol_va_memo_txn.save.should == true
    end
  end
  
  context 'get_reference_no' do
    it 'should return the reference_no for EcolVaTxn record' do
      ecol_va_memo_txn1 = Factory(:ecol_va_memo_txn, :approval_status => 'A')
      ecol_va_memo_txn2 = Factory(:ecol_va_memo_txn, :approval_status => 'A')
      ecol_va_memo_txn3 = Factory.build(:ecol_va_memo_txn, :approval_status => 'U')
      ecol_va_memo_txn3.get_reference_no.should == 'REF3'
    end
  end
end
