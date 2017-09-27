# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ecol_remitter do
    incoming_file_id 1 
    customer_code {Factory(:ecol_customer, :approval_status => 'A').code}
    customer_subcode "MyString"
    remitter_code "MyString"
    credit_acct_no "1234567890"
    customer_subcode_email "foo@ruby.com"
    customer_subcode_mobile "9876543210"
    rmtr_name "MyStirng"
    rmtr_address "Mystring"
    rmtr_acct_no "Mystring"
    rmtr_email "foo@ruby.com"
    rmtr_mobile "9876543210"
    invoice_no "MyString"
    invoice_amt 1.23
    invoice_amt_tol_pct 1
    min_credit_amt 1.45
    max_credit_amt 1.43
    due_date "2015-09-09"
    due_date_tol_days 1
    udf1 "Mystring"
    udf2 "Mystring"
    udf3 "Mystring"
    udf4 "Mystring"
    udf5 "Mystring"
    udf6 "Mystring"
    udf7 "Mystring"
    udf8 "Mystring"
    udf9 "Mystring"
    udf10 "Mystring"
    udf11 "Mystring"
    udf12 "Mystring"
    udf13 "Mystring"
    udf14 "Mystring"
    udf15 "Mystring"
    udf16 "Mystring"
    udf17 "Mystring"
    udf18 "Mystring"
    udf19 "Mystring"
    udf20 "Mystring"
    approval_status 'U'
    last_action 'C'
  end
end
