require 'spec_helper'
describe EcolCustomer do  
  include HelperMethods
  
  before(:each) do
    mock_ldap
  end

  context 'association' do
    it { should belong_to(:created_user) }
    it { should belong_to(:updated_user) }
    it { should have_one(:unapproved_record_entry) }
    it { should belong_to(:unapproved_record) }
    it { should belong_to(:approved_record) }
  end
  
  context 'validation' do
    [:code, :name, :is_enabled, :val_method, :token_1_type, :token_1_length, :val_token_1, :token_2_type, :token_2_length, 
      :val_token_2, :token_3_type, :token_3_length, :val_token_3, :val_txn_date, :val_txn_amt, :val_ben_name, :val_rem_acct, 
      :return_if_val_reject, :nrtv_sufx_1, :nrtv_sufx_2, :nrtv_sufx_3, :rmtr_alert_on, :credit_acct_val_pass,
      :customer_id, :should_prevalidate].each do |att|
      it { should validate_presence_of(att) }
    end 
       
    it do 
      ecol_customer = Factory(:ecol_customer, :approval_status => 'A')
      should validate_uniqueness_of(:code).scoped_to(:approval_status)
    end
    
    it do
      ecol_customer = Factory(:ecol_customer)
      should validate_length_of(:code).is_at_least(1).is_at_most(15)

      should validate_length_of(:name).is_at_least(5).is_at_most(50)
      should validate_length_of(:customer_id).is_at_most(50)
      should validate_length_of(:identity_user_id).is_at_most(20)
      
      should validate_length_of(:credit_acct_val_pass).is_at_least(10).is_at_most(25)
      should validate_length_of(:credit_acct_val_fail).is_at_least(10).is_at_most(25)
      should validate_length_of(:pool_acct_no).is_at_least(15).is_at_most(15)

      [:rmtr_pass_txt, :rmtr_return_txt].each do |att|
        should validate_length_of(att).is_at_most(500)
      end

      should allow_value(nil).for(:identity_user_id)
    end
    
    it do
      ecol_customer = Factory(:ecol_customer)
      [:token_1_length, :token_2_length, :token_3_length].each do |att|
        should validate_numericality_of(att)
        should allow_value(0).for(att)
        should allow_value(29).for(att)
        should_not allow_value(30).for(att)
        should_not allow_value(-1).for(att)
        should allow_value(15).for(att)
      end
    end

    it do
      ecol_customer = Factory(:ecol_customer)
      [:customer_id].each do |att|
        should allow_value('209').for(att)
        should allow_value('29').for(att)
        should_not allow_value('030').for(att)
        should_not allow_value('-1').for(att)
        should allow_value('15').for(att)
      end
    end
    
    it do
      ecol_customer = Factory(:ecol_customer)
      should validate_inclusion_of(:val_method).in_array(['N', 'W', 'D', 'V'])
      should validate_inclusion_of(:rmtr_alert_on).in_array(['N', 'P', 'R', 'A'])
    end
    [:token_1_type, :token_2_type, :token_3_type].each do |att|
      it { should validate_inclusion_of(att).in_array(['N', 'SC', 'RC', 'IN']) }
    end
    [:nrtv_sufx_1, :nrtv_sufx_2, :nrtv_sufx_3].each do |att|
      it { should validate_inclusion_of(att).in_array(['N', 'SC', 'RC', 'IN', 'RN', 'ORN', 'ORA', 'TUN', 'UDF1', 'UDF2']) }
    end

    it "should validate_unapproved_record" do 
      ecol_customer1 = Factory(:ecol_customer,:approval_status => 'A')
      ecol_customer2 = Factory(:ecol_customer, :approved_id => ecol_customer1.id)
      ecol_customer1.should_not be_valid
      ecol_customer1.errors_on(:base).should == ["Unapproved Record Already Exists for this record"]
    end

    it "should validate app_code" do 
      ecol_customer = Factory.build(:ecol_customer, :val_method => 'W', :app_code => nil)
      ecol_customer.should_not be_valid
      ecol_customer.errors_on(:app_code).should == ["Can't be blank if Validation Method is Web Service or Customer Alert is On"]

      ecol_customer = Factory.build(:ecol_customer, :cust_alert_on => 'A', :app_code => nil)
      ecol_customer.should_not be_valid
      ecol_customer.errors_on(:app_code).should == ["Can't be blank if Validation Method is Web Service or Customer Alert is On"]
      
      ecol_customer = Factory.build(:ecol_customer, :val_method => 'W', :cust_alert_on => 'A', :app_code => 'APP12')
      ecol_customer.should be_valid
      ecol_customer.errors_on(:app_code).should == []
    end
  end
  
  context "fields format" do 
    [:code, :app_code].each do |att|
      it "should allow valid format" do
        should allow_value('9876').for(att)
        should allow_value('ABCD9000').for(att)
      end 
    
      it "should not allow invalid format" do
        should_not allow_value('@CUST01').for(att)
        should_not allow_value('CUST01/').for(att)
        should_not allow_value('CUST-01').for(att)
      end     
    end
  end
  
  context "customer name format" do 
    it "should allow valid format" do     
      should allow_value('ABCDCo').for(:name)
      should allow_value('ABCD Co').for(:name)
    end 

    it "should not allow invalid format" do
      should_not allow_value('@AbcCo').for(:name)
      should_not allow_value('/ab0QWER').for(:name)
    end 
  end
  
  context "account no format" do 
    [:credit_acct_val_pass, :credit_acct_val_fail, :pool_acct_no].each do |att|
      it "should allow valid format" do
        should allow_value('123456789009876').for(att)
      end

      it "should not allow invalid format" do
        should_not allow_value('Absdjhsd').for(att)
        should_not allow_value('@AbcCo').for(att)
        should_not allow_value('/ab0QWER').for(att)
      end
    end 
  end
  
  context "sms text format" do 
    [:rmtr_pass_txt, :rmtr_return_txt].each do |att|
      it "should allow valid format" do
        should allow_value('ABCDCo').for(att)
        should allow_value('ABCD.Co').for(att)
        should allow_value('ABCD, Co').for(att)
      end 
  
      it "should not allow invalid format" do
        should_not allow_value('@AbcCo').for(att)
        should_not allow_value('/ab0QWER').for(att)
      end 
    end
  end
  
  context "cross-field validations" do 

    [
      %w( D F ),
      %w( D I )
    ].each do |val_method, file_upld_mthd|
        it "allows the combination val_method=#{val_method} and file_upld_mthd=#{file_upld_mthd}" do
          ecol_customer = Factory.build(:ecol_customer, :file_upld_mthd => file_upld_mthd, :val_method => val_method, :app_code => nil, :should_prevalidate => 'N')
          ecol_customer.save.should == true
        end
      end
    
    [
      %w( N I ),
      %w( N F ),
      %w( D P ),
      %w( W Q )
    ].each do |val_method, file_upld_mthd|
        it "does not allow the combination val_method=#{val_method} and file_upld_mthd=#{file_upld_mthd}" do
          ecol_customer = Factory.build(:ecol_customer, :file_upld_mthd => file_upld_mthd, :val_method => val_method)
          ecol_customer.save.should == false
        end
    end
        
    it "should check if val_tokens are N if val_method is N" do 
      ecol_customer = Factory.build(:ecol_customer, :val_method => "N", :val_token_1 => "Y", :val_token_2 => "Y", 
      :val_token_3 => "N", :val_txn_date => "N", :val_txn_amt => "P", :app_code => nil, :should_prevalidate => 'N')
      ecol_customer.save.should == false
      ecol_customer.errors[:base].should == ["If Validation Method is None, then all the Validation Account Tokens should also be N"]
    end
    
    it "should check if file_upld_mthd is present if val_method is D" do
      ecol_customer = Factory.build(:ecol_customer, :val_method => "D", :file_upld_mthd => nil)
      ecol_customer.save.should == false
      ecol_customer.errors_on(:file_upld_mthd).should == ["Can't be blank or None if Validation Method is Database Lookup"]

      ecol_customer = Factory.build(:ecol_customer, :val_method => "N", :file_upld_mthd => "F")
      ecol_customer.save.should == false
      ecol_customer.errors_on(:file_upld_mthd).should == ["Can't be selected as Validation Method is not Database Lookup"]
    end
    
    it "should check the value of all account tokens" do 
      ecol_customer = Factory.build(:ecol_customer, :token_1_type => "SC", :token_1_length => 1, :token_2_type => "SC", :token_2_length => 1, :token_3_type => "SC", :token_3_length => 1)
      ecol_customer.save.should == false
      ecol_customer.errors[:base].should == ["Can't allow same value for all tokens except for 'None'"]
      
      ecol_customer = Factory.build(:ecol_customer, :token_1_type => "N", :token_2_type => "N", :token_3_type => "N")
      ecol_customer.save.should == true
      ecol_customer.errors[:base].should == []
    end
    
    it "should check the value of acct token 2 & 3 if acct token 1 is N" do
      ecol_customer = Factory.build(:ecol_customer, :token_1_type => "N", :token_2_type => "SC", :token_2_length => 1, :token_3_type => "IN", :token_3_length => 1)
      ecol_customer.save.should == false
      ecol_customer.errors[:base].should == ["If Account Token 1 is None, then Account Token 2 & Account Token 3 should also be None"]
    end
    
    it "should check the value of acct token 3 if acct token 2 is N" do
      ecol_customer = Factory.build(:ecol_customer, :token_1_type => "IN", :token_1_length => 1, :token_2_type => "N", :token_3_type => "SC", :token_3_length => 1)
      ecol_customer.save.should == false
      ecol_customer.errors[:base].should == ["If Account Token 2 is None, then Account Token 3 also should be None"]
    end
    
    it "should check the value of all narration suffixes" do
      ecol_customer = Factory.build(:ecol_customer, :nrtv_sufx_1 => "RC", :nrtv_sufx_2 => "RC", :nrtv_sufx_3 => "RC")
      ecol_customer.save.should == false
      ecol_customer.errors[:base].should == ["Can't allow same value for all narration suffixes except for 'None'"]
      
      ecol_customer = Factory.build(:ecol_customer, :nrtv_sufx_1 => "N", :nrtv_sufx_2 => "N", :nrtv_sufx_3 => "N")
      ecol_customer.save.should == true
      ecol_customer.errors[:base].should == []
    end
      
    it "should check presence of rmtr_pass_txt if rmtr_alert_on is P or A" do
      ecol_customer = Factory.build(:ecol_customer, :rmtr_alert_on => "P", :rmtr_pass_txt => nil)
      ecol_customer.save.should == false
      ecol_customer.errors_on(:rmtr_pass_txt).should == ["Can't be blank if Send Alerts To Remitter On is On Pass or Always"]
    end
    
    it "should check presence of rmtr_return_txt if rmtr_alert_on is R or A" do  
      ecol_customer = Factory.build(:ecol_customer, :rmtr_alert_on => "R", :rmtr_return_txt => nil)
      ecol_customer.save.should == false
      ecol_customer.errors_on(:rmtr_return_txt).should == ["Can't be blank if Send Alerts To Remitter On is On Return or Always"]
    end
    
    it "should check values of nrtx_sufxs 2 & 3 if nrtv_sufx_1 is N" do
      ecol_customer = Factory.build(:ecol_customer, :nrtv_sufx_1 => "N", :nrtv_sufx_2 => "SC", :nrtv_sufx_3 => "RC")
      ecol_customer.save.should == false
      ecol_customer.errors[:base].should == ["If Narrative Suffix 1 is None, then Narrative Suffix 2 & Narrative Suffix 3 should also be None"]
    end
      
    it "should check value of nrtv_sufx_3 is nrtv_sufx_1 is N" do  
      ecol_customer = Factory.build(:ecol_customer, :nrtv_sufx_1 => "RC", :nrtv_sufx_2 => "N", :nrtv_sufx_3 => "SC")
      ecol_customer.save.should == false
      ecol_customer.errors[:base].should == ["If Narrative Suffix 2 is None, then Narrative Suffix 3 also should be None"]
    end
    
    it "should check if crefit_acct_val_fail is present if return_if_val_fail is N" do
      ecol_customer = Factory.build(:ecol_customer, :val_method => 'W', :return_if_val_reject => 'N', :credit_acct_val_fail => nil)
      ecol_customer.save.should == false
      ecol_customer.errors_on(:credit_acct_val_fail).should == ["Since transaction is not to be returned on validation failure(as 'Return if Validation Fails' box is unchecked) Credit Account No(Validation Fail) field cannot be blank"]
    end
    
    it "should check if should_prevalidate is enabled when val_method != W and cust_alert is off" do
      ecol_customer = Factory.build(:ecol_customer, val_method: 'D', cust_alert_on: 'N', should_prevalidate: 'Y')
      ecol_customer.save.should == false
      ecol_customer.errors_on(:should_prevalidate).should == ['should not be enabled when Validation Method is not Web Service and Customer Alert is off', "should be disabled when Validation Method is Database Lookup"]

      ecol_customer1 = Factory.build(:ecol_customer, val_method: 'W', cust_alert_on: 'N', should_prevalidate: 'Y')
      ecol_customer1.save.should == true
      
      ecol_customer2 = Factory.build(:ecol_customer, val_method: 'N', cust_alert_on: 'A', should_prevalidate: 'Y')
      ecol_customer2.save.should == true
    end
    
    it "should validate presence/absence of the combination of identity_user_id and allowed_operations" do
      ecol_customer = Factory.build(:ecol_customer, allowed_operations: nil, identity_user_id: '12345')
      ecol_customer.save.should == false
      ecol_customer.errors_on(:allowed_operations).should == ["can't be blank when Identity User ID is present"]
      
      ecol_customer = Factory.build(:ecol_customer, allowed_operations: ['getStatus'], identity_user_id: nil)
      ecol_customer.save.should == false
      ecol_customer.errors_on(:identity_user_id).should == ["can't be blank when Allowed Operations is present"]
      
      ecol_customer = Factory.build(:ecol_customer, allowed_operations: nil, identity_user_id: nil)
      ecol_customer.save.should == true
      ecol_customer.errors_on(:allowed_operations).should == []
      ecol_customer.errors_on(:identity_user_id).should == []
      
      ecol_customer = Factory.build(:ecol_customer, allowed_operations: ['getStatus'], identity_user_id: '12345')
      ecol_customer.save.should == true
      ecol_customer.errors_on(:allowed_operations).should == []
      ecol_customer.errors_on(:identity_user_id).should == []
    end
    
    it "should check 'acceptPaymentWithCreditAcctNo' and 'acceptPayment' can't be together" do 
      ecol_customer = Factory.build(:ecol_customer, allowed_operations: ['acceptPaymentWithCreditAcctNo', 'acceptPayment'])
      ecol_customer.save.should == false
      ecol_customer.errors_on(:allowed_operations).should == ["both 'acceptPayment' and 'acceptPaymentWithCreditAcctNo' cannot be selected, choose any one of the two"]
    end

    it "should check returnPayment is not allowed if return_valus is false" do 
      ecol_customer = Factory.build(:ecol_customer, allowed_operations: ['returnPayment'], return_if_val_reject: "N")
      ecol_customer.save.should == false
      ecol_customer.errors_on(:allowed_operations).should == ["returnPayment is not allowed if Return If Validation Fails is 'N'"]
      
      ecol_customer = Factory.build(:ecol_customer, allowed_operations: ['returnPayment'], return_if_val_reject: "Y")
      ecol_customer.save.should == true
    end
    
    it "should allow only one token if val_method is V" do
      ecol_customer = Factory.build(:ecol_customer, val_method: 'V', :token_1_type => "SC", :token_1_length => 1, :token_2_type => "IN", :token_2_length => 1)
      ecol_customer.save.should == false
      ecol_customer.errors_on(:base).should == ["Only one token is allowed when the Validation Method is Virtual Account"]
      
      ecol_customer = Factory.build(:ecol_customer, val_method: 'V', :token_1_type => "SC", :token_1_length => 1, :token_2_type => 'N')
      ecol_customer.save.should == true
    end
  end
  
  context "options_for_select_boxes" do
    it "should return options for val method" do
      EcolCustomer.options_for_val_method.should == [['None','N'],['Web Service','W'],['Database Lookup','D'],['Virtual Account','V']]
    end
    
    it "should return options for acct tokens" do
      EcolCustomer.options_for_acct_tokens.should == [['None','N'],['Sub Code','SC'],['Remitter Code','RC'],['Invoice Number','IN']]
    end
    
    it "should return options for customer alert" do
      EcolCustomer.options_for_customer_alert.should == [['Always','A'],['On Credit','P'],['On Return','R'],['Never','N']]
    end

    it "should return options for file upld mthd" do
      EcolCustomer.options_for_file_upld_mthd.should == [['None','N'],['Full', 'F'],['Incremental','I']]
    end
    
    it "should return options for nrtv sufxs" do
      EcolCustomer.options_for_nrtv_sufxs.should == [['None','N'],['Sub Code','SC'],['Remitter Code','RC'],['Invoice Number','IN'],['Remitter Name','RN'],['Original Remitter Name','ORN'],['Original Remitter Account','ORA'],['Transfer Unique No','TUN'],['User Defined Field 1','UDF1'],['User Defined Field 2','UDF2']]
    end
    
    it "should return options for rmtr alert on" do
      EcolCustomer.options_for_rmtr_alert_on == [['Never','N'],['On Pass','P'],['On Return','R'],['Always','A']]
    end

    it "should return options for val txn date" do
      EcolCustomer.options_for_val_txn_amt == [['None','N'],['Exact','E'],['Range','R']]
    end
    
    it "should return options for val txn amt" do
      EcolCustomer.options_for_val_txn_amt == [['None','N'],['Exact','E'],['Range','R'],['Percentage','P']]
    end
  end
  
  context "customer_code_format" do
    it "should validate customer code format" do
      ecol_customer = Factory(:ecol_customer, :code => '4876', :approval_status => 'A')
      ecol_customer = Factory.build(:ecol_customer, :code => '487678', :approval_status => 'A')
      ecol_customer.save.should == false
      ecol_customer.errors_on(:code).should == ["starting with 4876 is already taken"]
      
      ecol_customer = Factory(:ecol_customer, :code => '5876AS', :approval_status => 'A')
      ecol_customer = Factory.build(:ecol_customer, :code => '5876', :approval_status => 'A')
      ecol_customer.save.should == false
      ecol_customer.errors_on(:code).should == ["starting with 5876 is already taken"]
      
      ecol_customer = Factory.build(:ecol_customer, :code => '5876OP', :approval_status => 'A')
      ecol_customer.save.should == true

      ecol_customer = Factory(:ecol_customer, :code => 'QWER89', :approval_status => 'A')
      ecol_customer.code = 'QWER'
      ecol_customer.save.should == true

      ecol_customer = Factory.build(:ecol_customer, :code => '8ABC')
      ecol_customer.save.should == true
      
      ecol_customer = Factory.build(:ecol_customer, :code => 'GABC')
      ecol_customer.save.should == true
      
      ecol_customer = Factory.build(:ecol_customer, :code => '9876')
      ecol_customer.save.should == true
      
      ecol_customer = Factory.build(:ecol_customer, :code => '87609')
      ecol_customer.save.should == false

      ecol_customer = Factory.build(:ecol_customer, :code => '876098')
      ecol_customer.save.should == true

      ecol_customer = Factory.build(:ecol_customer, :code => '87609889')
      ecol_customer.save.should == true
      
      ecol_customer = Factory.build(:ecol_customer, :code => 'abcdefhj')
      ecol_customer.save.should == true
      
      ecol_customer = Factory.build(:ecol_customer, :code => '98760988767')
      ecol_customer.save.should == false
      ecol_customer.errors_on(:code).should == ["the code can be either a 4 digit number starting with 9, or a 6 character alpha-numeric code, that does not start with 9, or a 8 character alpha-numeric code, that does not start with 9, or 6 characters alpha-numeric code starting with 9 and next 3 characters are non numbers"]

      ecol_customer = Factory.build(:ecol_customer, :code => 'ABCD0123456')
      ecol_customer.save.should == true

      ecol_customer = Factory.build(:ecol_customer, :code => '123456789011')
      ecol_customer.save.should == false
      ecol_customer.errors_on(:code).should == ['the code can be either a 4 character alpha-numeric code , or a 6 character alpha-numeric code, that does not start with 9, or a 8 character alpha-numeric code, that does not start with 9, or alphanumeric (with format [A-Z|a-z]{4}[0][A-Za-z0-9]{6}) with 11 characters']

      ecol_customer = Factory.build(:ecol_customer, :code => '9iuy99')
      ecol_customer.save.should == true

      ecol_customer = Factory.build(:ecol_customer, :code => '9iUN99')
      ecol_customer.save.should == true

      ecol_customer = Factory.build(:ecol_customer, :code => '9iuyi9')
      ecol_customer.save.should == true

      ecol_customer = Factory.build(:ecol_customer, :code => '987i98')
      ecol_customer.save.should == true

      ecol_customer = Factory.build(:ecol_customer, :code => '987998')
      ecol_customer.save.should == false
      ecol_customer.errors_on(:code).should == ["the code can be either a 4 digit number starting with 9, or a 6 character alpha-numeric code, that does not start with 9, or a 8 character alpha-numeric code, that does not start with 9, or 6 characters alpha-numeric code starting with 9 and next 3 characters are non numbers"]

      ecol_customer = Factory.build(:ecol_customer, :code => '9hju899')
      ecol_customer.save.should == false
      ecol_customer.errors_on(:code).should == ["the code can be either a 4 digit number starting with 9, or a 6 character alpha-numeric code, that does not start with 9, or a 8 character alpha-numeric code, that does not start with 9, or 6 characters alpha-numeric code starting with 9 and next 3 characters are non numbers"]
    end
  end

  context "account_token_types" do
    it "returns an array of account tokens" do 
      ecol_customer = Factory(:ecol_customer)
      ecol_customer.account_token_types.should == [ecol_customer.token_1_type, ecol_customer.token_2_type, ecol_customer.token_3_type]
    end
  end
  
  context "validate_account_token_length" do
    it "should validate length of account tokens" do
      ecol_customer = Factory.build(:ecol_customer, :token_1_type => 'SC', :token_1_length => 1)
      ecol_customer.save == true
      ecol_customer = Factory.build(:ecol_customer, :token_1_type => 'SC', :token_1_length => 0)
      ecol_customer.save == false
      ecol_customer = Factory.build(:ecol_customer, :token_1_type => 'N', :token_1_length => 0)
      ecol_customer.save == true    
    end
  end
  
  context "default_scope" do 
    it "should only return 'A' records by default" do 
      ecol_customer1 = Factory(:ecol_customer, :approval_status => 'A') 
      ecol_customer2 = Factory(:ecol_customer)
      EcolCustomer.all.should == [ecol_customer1]
      ecol_customer2.approval_status = 'A'
      ecol_customer2.save
      EcolCustomer.all.should == [ecol_customer1,ecol_customer2]
    end
  end    

  context "unapproved_record_entrys" do 
    it "oncreate: should create unapproved_record_entry if the approval_status is 'U'" do
      ecol_customer = Factory(:ecol_customer)
      ecol_customer.reload
      ecol_customer.unapproved_record_entry.should_not be_nil
    end

    it "oncreate: should not create unapproved_record_entry if the approval_status is 'A'" do
      ecol_customer = Factory(:ecol_customer, :approval_status => 'A')
      ecol_customer.unapproved_record_entry.should be_nil
    end

    it "onupdate: should not remove unapproved_record_entry if approval_status did not change from U to A" do
      ecol_customer = Factory(:ecol_customer)
      ecol_customer.reload
      ecol_customer.unapproved_record_entry.should_not be_nil
      record = ecol_customer.unapproved_record_entry
      # we are editing the U record, before it is approved
      ecol_customer.name = 'Fooo'
      ecol_customer.save
      ecol_customer.reload
      ecol_customer.unapproved_record_entry.should == record
    end
    
    it "onupdate: should remove unapproved_record_entry if the approval_status changed from 'U' to 'A' (approval)" do
      ecol_customer = Factory(:ecol_customer)
      ecol_customer.reload
      ecol_customer.unapproved_record_entry.should_not be_nil
      # the approval process changes the approval_status from U to A for a newly edited record
      ecol_customer.approval_status = 'A'
      ecol_customer.save
      ecol_customer.reload
      ecol_customer.unapproved_record_entry.should be_nil
    end
    
    it "ondestroy: should remove unapproved_record_entry if the record with approval_status 'U' was destroyed (approval) " do
      ecol_customer = Factory(:ecol_customer)
      ecol_customer.reload
      ecol_customer.unapproved_record_entry.should_not be_nil
      record = ecol_customer.unapproved_record_entry
      # the approval process destroys the U record, for an edited record 
      ecol_customer.destroy
      UnapprovedRecord.find_by_id(record.id).should be_nil
    end
  end

  context "approve" do 
    it "should approve unapproved_record" do 
      ecol_customer = Factory(:ecol_customer, :approval_status => 'U')
      ecol_customer.approve.save.should == true
      ecol_customer.approval_status.should == 'A'
    end

    it "should return error when trying to approve unmatched version" do 
      ecol_customer = Factory(:ecol_customer, :approval_status => 'A')
      ecol_customer2 = Factory(:ecol_customer, :approval_status => 'U', :approved_id => ecol_customer.id, :approved_version => 6)
      ecol_customer2.approve.should == "The record version is different from that of the approved version" 
    end
  end

  context "enable_approve_button?" do 
    it "should return true if approval_status is 'U' else false" do 
      ecol_customer1 = Factory(:ecol_customer, :approval_status => 'A')
      ecol_customer2 = Factory(:ecol_customer, :approval_status => 'U')
      ecol_customer1.enable_approve_button?.should == false
      ecol_customer2.enable_approve_button?.should == true
    end
  end
  
  context "value_of_validation_fields" do
    it "should validate value of validate fields" do
      ecol_customer = Factory.build(:ecol_customer, :approval_status => 'A', :val_method => 'W', :val_token_1 => 'N', :val_token_2 => 'N', :val_token_3 => 'N', 
      :val_txn_date => 'Y', :val_txn_amt => 'Y', :val_rem_acct => 'Y')
      ecol_customer.save.should == false
      ecol_customer.errors[:base].should == ["Transaction Date, Transaction Amount and Remitter Account cannot be validated as no Token is validated"]
    end
  end
  
  context "to_upcase" do
    it "should convert values to upcase before save" do
      ecol_customer = Factory(:ecol_customer, :code => "as89nnmm", :token_1_starts_with => "qwerty", :token_1_contains => "asdfg", :token_1_ends_with => "uiop")
      ecol_customer.code.should == "AS89NNMM"
      ecol_customer.token_1_starts_with.should == "QWERTY"
      ecol_customer.token_1_contains.should == "ASDFG"
      ecol_customer.token_1_ends_with.should == "UIOP"
    end
  end

  context "val_method is equal D" do    
    it "should not validate  if should_prevalidate is Y" do 
      ecol_customer = Factory.build(:ecol_customer, :val_method => "D", :should_prevalidate => 'Y' )
      ecol_customer.save.should == false
      ecol_customer.errors_on(:should_prevalidate).should include("should be disabled when Validation Method is Database Lookup")
    end
  
    it "should validate  if app_code is not present and should_prevalidate is 'N' " do 
      ecol_customer = Factory.build(:ecol_customer, :app_code => nil, :val_method => 'D', :should_prevalidate => 'N',:file_upld_mthd => 'I')
      ecol_customer.save.should == true
    end
  end
  # context "presence_of_iam_cust_user" do
  #   it "should validate existence of iam_cust_user" do
  #     ecol_customer = Factory.build(:ecol_customer, identity_user_id: '1234')
  #     ecol_customer.errors_on(:identity_user_id).should == ['IAM Customer User does not exist for this username']
  #
  #     iam_cust_user = Factory(:iam_cust_user, username: '1234', approval_status: 'A')
  #     ecol_customer.errors_on(:identity_user_id).should == []
  #
  #     ecol_customer = Factory.build(:ecol_customer, identity_user_id: nil)
  #     ecol_customer.errors_on(:identity_user_id).should == []
  #   end
  # end
end
