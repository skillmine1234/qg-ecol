FactoryGirl.define do
  factory :ecol_incoming_file do
    file_name {Factory(:incoming_file).file_name}
  end
end