# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :qg_ecol_todays_imps_txn do
    sequence(:rrn) {|n| "9" + "%04i" % "#{n}" }
    sequence(:transfer_unique_no) {|n| "7" + "%05i" % "#{n}" }
    transfer_type "IMPS"
    transfer_status "MyString"
    rmtr_ref "MyString"
    bene_account_ifsc "ASDF0123456"
    bene_account_no "MyString"
    bene_account_type "MyString"
    rmtr_account_ifsc "ASDF0543210"
    rmtr_account_no "MyString"
    rmtr_account_type "MyString"
    transfer_amt 1
    transfer_ccy "INR"
    transfer_date "2016-05-05 10:04:40"
    pool_account_no "MyString"
    rmtr_to_bene_note "MyString"
    rmtr_full_name "MyString"
    rmtr_address "MyString"
    bene_full_name "MyString"
    status "S"
    error_code "MyString"
  end
end