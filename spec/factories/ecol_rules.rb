# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ecol_rule do
    ifsc "ABCD0123456"
    cod_acct_no "1234567890"
    stl_gl_inward "1234567890"
    approval_status 'U'
    last_action 'C'
    neft_sender_ifsc 'ASDF0123456'
    customer_id 'KFCJSDH'
    return_account_no '2345678901'
  end
end
