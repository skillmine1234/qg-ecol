# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :udf_attribute do
    class_name "EcolRemitter"
    sequence(:attribute_name) {|n| "udf#{n}" }
    is_enabled 'N'
    is_mandatory 'N'
    control_type 'CheckBox'
    select_options "---\n name1: value1"
    approval_status 'U'
    last_action 'C'
  end

  factory :ecol_remitter_custom_field, :parent => :udf_attribute, :class => 'EcolRemitterCustomField' do
  end
end
