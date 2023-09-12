# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ecol_app_udtable do
    app_code {Factory(:ecol_app, approval_status: 'A').app_code}
    udf1 'udf1'
    approval_status "U"
    last_action "C"
    lock_version 1
    approved_version 1
  end
end