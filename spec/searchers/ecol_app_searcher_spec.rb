require 'spec_helper'

describe EcolAppSearcher do
  context 'searcher' do
    it 'should return ecol_app' do
      ecol_customer = Factory(:ecol_customer, code: 'CUST01', val_method: 'W', approval_status: 'A')
      ecol_app = Factory(:ecol_app, app_code: 'ECSTDX01', customer_code: ecol_customer.code, validate_url: 'https://google.com', approval_status: 'A')
      EcolAppSearcher.new({app_code: 'ECSTDX01', approval_status: 'A'}).paginate.should == [ecol_app]
      EcolAppSearcher.new({app_code: 'ECSTDX02', approval_status: 'A'}).paginate.should == []

      ecol_customer = Factory(:ecol_customer, code: 'CUST02', val_method: 'W', approval_status: 'A')
      ecol_app = Factory(:ecol_app, app_code: 'ECSTDX01', customer_code: ecol_customer.code, validate_url: 'https://google.com', approval_status: 'A')
      EcolAppSearcher.new({customer_code: 'CUST02', approval_status: 'A'}).paginate.should == [ecol_app]
      EcolAppSearcher.new({customer_code: 'CUST03', approval_status: 'A'}).paginate.should == []
    end
  end
end
