# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ecol_customer do
    sequence(:code) {|n| "9" + "%03i" % "#{n}" }
    name "MyString"
    is_enabled "Y"
    val_method "N"
    token_1_type "N"
    token_1_length 0
    val_token_1 "N"
    token_2_type "N"
    token_2_length 0
    val_token_2 "N"
    token_3_type "N"
    token_3_length 0
    val_token_3 "N"
    val_txn_date "N"
    val_txn_amt "N"
    val_ben_name "N"
    val_rem_acct "N"
    return_if_val_reject "N"
    file_upld_mthd "N"
    credit_acct_val_pass "0987654321"
    credit_acct_val_fail "1234567890"
    nrtv_sufx_1 "N"
    nrtv_sufx_2 "N"
    nrtv_sufx_3 "N"
    rmtr_alert_on "N"
    rmtr_pass_txt "MyString"
    rmtr_return_txt "MyString"
    approval_status 'U'
    last_action 'C'
    customer_id 1234
    app_code "1234"
    identity_user_id { Factory(:iam_cust_user, approval_status: 'A').username }
    allowed_operations ['getStatus']
    should_prevalidate 'N'
  end
end
