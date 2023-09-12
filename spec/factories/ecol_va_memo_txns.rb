# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ecol_va_memo_txn do
    sequence(:reference_no) { [*('A'..'Z')].sample(4).join }
    customer_code { Factory.create(:ecol_customer, val_method: 'V', approval_status: 'A').code}
    account_no '1234567890'
    txn_amount 100
    txn_type 'CREDIT'
    approval_status "U"
    last_action "C"
    lock_version 1
    approved_version 1
  end
end