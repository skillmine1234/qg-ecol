require 'spec_helper'

describe EcolAppUdtableSearcher do

  context 'searcher' do
    it 'should return ecol_app_udtable records for a specific app code' do
      ecol_app = Factory(:ecol_app, approval_status: 'A')
      ecol_app_udtable = Factory(:ecol_app_udtable, app_code: ecol_app.app_code, approval_status: 'A')
      EcolAppUdtableSearcher.new({app_code: ecol_app.app_code}).paginate.should == [ecol_app_udtable]
      EcolAppUdtableSearcher.new({app_code: '123'}).paginate.should == []
    end
  end
end