require 'spec_helper'

describe QgEcolTodaysRtgsTxn do
  
  context 'validation' do
    [:transfer_unique_no, :rmtr_ref, :bene_account_ifsc, :bene_account_no, :rmtr_account_ifsc, :rmtr_account_no, :transfer_amt, :transfer_date, :rmtr_full_name].each do |att|
      it { should validate_presence_of(att) }
    end
    
    it "should validate IFSC format" do
      qg_ecol_todays_rtgs_txn = Factory.build(:qg_ecol_todays_rtgs_txn, :bene_account_ifsc => "ABCD0123456", :rmtr_account_ifsc => "QWER0123456")
      qg_ecol_todays_rtgs_txn.should be_valid

      qg_ecol_todays_rtgs_txn = Factory.build(:qg_ecol_todays_rtgs_txn, :bene_account_ifsc => "abcd0QWERTY", :rmtr_account_ifsc => "abcd0QWERTY")
      qg_ecol_todays_rtgs_txn.should be_valid

      qg_ecol_todays_rtgs_txn = Factory.build(:qg_ecol_todays_rtgs_txn, :bene_account_ifsc => "abcd0QWE123", :rmtr_account_ifsc => "abcd0QWE456")
      qg_ecol_todays_rtgs_txn.should be_valid

      qg_ecol_todays_rtgs_txn = Factory.build(:qg_ecol_todays_rtgs_txn, :bene_account_ifsc => "abcd11234bh", :rmtr_account_ifsc => "abcd11234ch")
      qg_ecol_todays_rtgs_txn.should_not be_valid
      qg_ecol_todays_rtgs_txn.errors_on(:bene_account_ifsc).should == ["invalid format - expected format is : {[A-Z|a-z]{4}[0][A-Za-z0-9]{6}}"]
      qg_ecol_todays_rtgs_txn.errors_on(:rmtr_account_ifsc).should == ["invalid format - expected format is : {[A-Z|a-z]{4}[0][A-Za-z0-9]{6}}"]

      qg_ecol_todays_rtgs_txn = Factory.build(:qg_ecol_todays_rtgs_txn, :bene_account_ifsc => "abcdQWERTY", :rmtr_account_ifsc => "abcdQWERTY")
      qg_ecol_todays_rtgs_txn.should_not be_valid

      qg_ecol_todays_rtgs_txn = Factory.build(:qg_ecol_todays_rtgs_txn, :bene_account_ifsc => "ab0QWER", :rmtr_account_ifsc => "ab0QWER")
      qg_ecol_todays_rtgs_txn.should_not be_valid

      qg_ecol_todays_rtgs_txn = Factory.build(:qg_ecol_todays_rtgs_txn, :bene_account_ifsc => "ab@#0QWER", :rmtr_account_ifsc => "ab@#0QWER")
      qg_ecol_todays_rtgs_txn.should_not be_valid
    end

    it "should validate transfer_amt" do
      qg_ecol_todays_rtgs_txn = Factory.build(:qg_ecol_todays_rtgs_txn, :transfer_amt => 200001)
      qg_ecol_todays_rtgs_txn.should be_valid
      qg_ecol_todays_rtgs_txn = Factory.build(:qg_ecol_todays_rtgs_txn, :transfer_amt => 200000)
      qg_ecol_todays_rtgs_txn.should be_valid
      qg_ecol_todays_rtgs_txn = Factory.build(:qg_ecol_todays_rtgs_txn, :transfer_amt => 199999)
      qg_ecol_todays_rtgs_txn.should_not be_valid
    end
  end
end
