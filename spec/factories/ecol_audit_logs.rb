# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ecol_audit_log do
    ecol_transaction_id 1
    step_name "MyString"
    attempt_no 1
    fault_code "MyString"
    fault_reason "MyString"
    req_bitstream "MyText"
    rep_bitstream "MyText"
    fault_bitstream "MyText"
  end
end
