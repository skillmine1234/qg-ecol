FactoryGirl.define do
  factory :ecol_incoming_record do
    incoming_file_record_id {Factory(:incoming_file_record, :incoming_file => Factory(:incoming_file,:file_type => 'RMTRS',:service_name => 'ECOL')).id}
    sequence(:file_name) {|n| "file#{n}"} 
    customer_code 'CUST01'
    remitter_code 'RMTR01'
  end
end