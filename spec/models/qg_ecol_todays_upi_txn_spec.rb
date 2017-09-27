require 'spec_helper'

describe QgEcolTodaysUpiTxn do
  
  context 'validation' do
    [:rrn, :transfer_unique_no, :bene_account_ifsc, :bene_account_no, :rmtr_account_ifsc, :rmtr_account_no, :transfer_amt, 
     :transfer_date, :pool_account_no].each do |att|
      it { should validate_presence_of(att) }
    end

    it do
      should validate_length_of(:rrn).is_at_most(30)
      [:transfer_type, :error_code].each do |att|
        should validate_length_of(att).is_at_most(3)
      end
      should validate_length_of(:transfer_status).is_at_most(25)
      [:transfer_unique_no, :rmtr_ref, :bene_account_no, :rmtr_account_no].each do |att|
        should validate_length_of(att).is_at_most(64)
      end
      [:bene_account_ifsc, :rmtr_account_ifsc, :pool_account_no].each do |att|
        should validate_length_of(att).is_at_most(20)
      end
      [:bene_account_type, :rmtr_account_type].each do |att|
        should validate_length_of(att).is_at_most(10)
      end
      should validate_length_of(:transfer_ccy).is_at_most(5)
      should validate_length_of(:status).is_at_most(4)
    end

    it "should validate IFSC format" do
      qg_ecol_todays_upi_txn = Factory.build(:qg_ecol_todays_upi_txn, :bene_account_ifsc => "ABCD0123456", :rmtr_account_ifsc => "QWER0123456")
      qg_ecol_todays_upi_txn.should be_valid

      qg_ecol_todays_upi_txn = Factory.build(:qg_ecol_todays_upi_txn, :bene_account_ifsc => "abcd0QWERTY", :rmtr_account_ifsc => "abcd0QWERTY")
      qg_ecol_todays_upi_txn.should be_valid

      qg_ecol_todays_upi_txn = Factory.build(:qg_ecol_todays_upi_txn, :bene_account_ifsc => "abcd0QWE123", :rmtr_account_ifsc => "abcd0QWE456")
      qg_ecol_todays_upi_txn.should be_valid

      qg_ecol_todays_upi_txn = Factory.build(:qg_ecol_todays_upi_txn, :bene_account_ifsc => "abcd11234bh", :rmtr_account_ifsc => "abcd11234ch")
      qg_ecol_todays_upi_txn.should_not be_valid
      qg_ecol_todays_upi_txn.errors_on(:bene_account_ifsc).should == ["invalid format - expected format is : {[A-Z|a-z]{4}[0][A-Za-z0-9]{6}}"]
      qg_ecol_todays_upi_txn.errors_on(:rmtr_account_ifsc).should == ["invalid format - expected format is : {[A-Z|a-z]{4}[0][A-Za-z0-9]{6}}"]

      qg_ecol_todays_upi_txn = Factory.build(:qg_ecol_todays_upi_txn, :bene_account_ifsc => "abcdQWERTY", :rmtr_account_ifsc => "abcdQWERTY")
      qg_ecol_todays_upi_txn.should_not be_valid

      qg_ecol_todays_upi_txn = Factory.build(:qg_ecol_todays_upi_txn, :bene_account_ifsc => "ab0QWER", :rmtr_account_ifsc => "ab0QWER")
      qg_ecol_todays_upi_txn.should_not be_valid

      qg_ecol_todays_upi_txn = Factory.build(:qg_ecol_todays_upi_txn, :bene_account_ifsc => "ab@#0QWER", :rmtr_account_ifsc => "ab@#0QWER")
      qg_ecol_todays_upi_txn.should_not be_valid
    end

    it "should validate transfer_amt" do
      qg_ecol_todays_upi_txn = Factory.build(:qg_ecol_todays_upi_txn, :transfer_amt => 100001)
      qg_ecol_todays_upi_txn.should_not be_valid

      qg_ecol_todays_upi_txn = Factory.build(:qg_ecol_todays_upi_txn, :transfer_amt => 100000)
      qg_ecol_todays_upi_txn.should be_valid

      qg_ecol_todays_upi_txn = Factory.build(:qg_ecol_todays_upi_txn, :transfer_amt => 99999)
      qg_ecol_todays_upi_txn.should be_valid
    end

    it "should validate uniqueness of transfer_unique_no" do
      qg_ecol_todays_neft_txn = Factory(:qg_ecol_todays_upi_txn)
      should validate_uniqueness_of(:transfer_unique_no)
    end
  end  
end
