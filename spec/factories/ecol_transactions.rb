# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ecol_transaction do
    status "MyString"
    transfer_type "abc"
    transfer_unique_no "MyString"
    transfer_status "MyString"
    transfer_timestamp "2015-04-20"
    transfer_ccy "abcde"
    transfer_amt 1
    rmtr_full_name "MyString"
    rmtr_account_no "MyString"
    rmtr_account_ifsc "MyString"
    bene_account_no "MyString"
    bene_account_ifsc "MyString"
    received_at "2015-05-10 12:12:00"
    pending_approval "N"
  end
end
