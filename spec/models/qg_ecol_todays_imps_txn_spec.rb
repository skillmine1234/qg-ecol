require 'spec_helper'

describe QgEcolTodaysImpsTxn do

  context 'validation' do
    [:rrn, :transfer_unique_no, :bene_account_ifsc, :bene_account_no, :rmtr_account_ifsc, :rmtr_account_no, :transfer_amt, :transfer_date, :pool_account_no, :status].each do |att|
      it { should validate_presence_of(att) }
    end
    
    it "should validate IFSC format" do
      qg_ecol_todays_imps_txn = Factory.build(:qg_ecol_todays_imps_txn, :bene_account_ifsc => "ABCD0123456", :rmtr_account_ifsc => "QWER0123456")
      qg_ecol_todays_imps_txn.should be_valid

      qg_ecol_todays_imps_txn = Factory.build(:qg_ecol_todays_imps_txn, :bene_account_ifsc => "abcd0QWERTY", :rmtr_account_ifsc => "abcd0QWERTY")
      qg_ecol_todays_imps_txn.should be_valid

      qg_ecol_todays_imps_txn = Factory.build(:qg_ecol_todays_imps_txn, :bene_account_ifsc => "abcd0QWE123", :rmtr_account_ifsc => "abcd0QWE456")
      qg_ecol_todays_imps_txn.should be_valid

      qg_ecol_todays_imps_txn = Factory.build(:qg_ecol_todays_imps_txn, :bene_account_ifsc => "abcd11234bh", :rmtr_account_ifsc => "abcd11234ch")
      qg_ecol_todays_imps_txn.should_not be_valid
      qg_ecol_todays_imps_txn.errors_on(:bene_account_ifsc).should == ["invalid format - expected format is : {[A-Z|a-z]{4}[0][A-Za-z0-9]{6}}"]
      qg_ecol_todays_imps_txn.errors_on(:rmtr_account_ifsc).should == ["invalid format - expected format is : {[A-Z|a-z]{4}[0][A-Za-z0-9]{6}}"]

      qg_ecol_todays_imps_txn = Factory.build(:qg_ecol_todays_imps_txn, :bene_account_ifsc => "abcdQWERTY", :rmtr_account_ifsc => "abcdQWERTY")
      qg_ecol_todays_imps_txn.should_not be_valid

      qg_ecol_todays_imps_txn = Factory.build(:qg_ecol_todays_imps_txn, :bene_account_ifsc => "ab0QWER", :rmtr_account_ifsc => "ab0QWER")
      qg_ecol_todays_imps_txn.should_not be_valid

      qg_ecol_todays_imps_txn = Factory.build(:qg_ecol_todays_imps_txn, :bene_account_ifsc => "ab@#0QWER", :rmtr_account_ifsc => "ab@#0QWER")
      qg_ecol_todays_imps_txn.should_not be_valid
    end

    it "should validate transfer_amt" do
      qg_ecol_todays_imps_txn = Factory.build(:qg_ecol_todays_imps_txn, :transfer_amt => 200001)
      qg_ecol_todays_imps_txn.should_not be_valid

      qg_ecol_todays_imps_txn = Factory.build(:qg_ecol_todays_imps_txn, :transfer_amt => 200000)
      qg_ecol_todays_imps_txn.should be_valid

      qg_ecol_todays_imps_txn = Factory.build(:qg_ecol_todays_imps_txn, :transfer_amt => 199999)
      qg_ecol_todays_imps_txn.should be_valid
    end

    it "should validate uniqueness of transfer_unique_no" do
      qg_ecol_todays_neft_txn = Factory(:qg_ecol_todays_imps_txn)
      should validate_uniqueness_of(:transfer_unique_no)
    end

    it "should validate uniqueness of rrn" do
      qg_ecol_todays_neft_txn = Factory(:qg_ecol_todays_imps_txn)
      should validate_uniqueness_of(:rrn)
    end
  end

end
