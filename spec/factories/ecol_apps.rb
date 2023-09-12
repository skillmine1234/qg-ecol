# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ecol_app do
    sequence(:app_code) {|n| "%03i" % "#{n}"}
    setting1_name 'udf1'
    setting1_type 'number'
    setting1_value '1234'
    notify_url 'http://localhost'
    approval_status "U"
    last_action "C"
    lock_version 1
    approved_version 1
    udf1_name 'udf1'
    udf1_type 'text'
    unique_udfs_cnt 1
  end
end