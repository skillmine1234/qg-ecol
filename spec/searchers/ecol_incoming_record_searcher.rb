require 'spec_helper'

describe EcolIncomingRecordSearcher do
  context 'searcher' do
    it 'should return ecol_incoming_records' do
      a = Factory(:ecol_incoming_record, :incoming_file_record => Factory(:incoming_file_record, :overrides => 'Y:76',:record_no => 23))
      EcolIncomingRecordSearcher.new({overrided_flag: "true",file_name: a.file_name, status: 'FAILED'}).paginate.should == [a]

      ecol_incoming_record = Factory(:ecol_incoming_record, :customer_code => '2222')
      EcolIncomingRecordSearcher.new({customer_code: '2222', file_name: ecol_incoming_record.file_name, status: 'FAILED'}).paginate.should == [ecol_incoming_record]
      EcolIncomingRecordSearcher.new({customer_code: '2223', file_name: ecol_incoming_record.file_name, status: 'FAILED'}).paginate.should == []

      ecol_incoming_record = Factory(:ecol_incoming_record, :file_name => 'File01', :remitter_code => 'YESB')
      EcolIncomingRecordSearcher.new({file_name: ecol_incoming_record.file_name, remitter_code: 'YESB', status: 'FAILED'}).paginate.should == [ecol_incoming_record]
      EcolIncomingRecordSearcher.new({file_name: ecol_incoming_record.file_name, remitter_code: 'HDFC', status: 'FAILED'}).paginate.should == []

      ecol_incoming_record = Factory(:ecol_incoming_record, :file_name => 'File02', :invoice_no => 'Job')
      EcolIncomingRecordSearcher.new({file_name: ecol_incoming_record.file_name, invoice_no: 'Job', status: 'FAILED'}).paginate.should == [ecol_incoming_record]
      EcolIncomingRecordSearcher.new({file_name: ecol_incoming_record.file_name, invoice_no: 'Foo', status: 'FAILED'}).paginate.should == []
    end
  end
end