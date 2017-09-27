require 'spec_helper'

describe EcolTransaction do
  
  context 'validation' do
    [:status, :transfer_type, :transfer_unique_no, :transfer_status, :transfer_timestamp, :transfer_ccy, 
      :transfer_amt, :rmtr_account_no, :rmtr_account_ifsc, :bene_account_no, 
      :bene_account_ifsc, :received_at].each do |att|
        it { should validate_presence_of(att) }
      end
      
      it { should validate_numericality_of(:transfer_amt)}
  end
end
