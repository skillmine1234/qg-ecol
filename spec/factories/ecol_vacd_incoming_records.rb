FactoryGirl.define do
  factory :ecol_vacd_incoming_record do
    incoming_file_record_id {Factory(:incoming_file_record, :incoming_file => Factory(:incoming_file,:file_type => 'VACD',:service_name => 'ECOL')).id}
    sequence(:file_name) {|n| "file#{n}"} 
    account_no '1234567890'
    txn_type 'MyString'
    txn_amount 100
  end
end