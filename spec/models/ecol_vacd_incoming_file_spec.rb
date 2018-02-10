require 'spec_helper'

describe EcolVacdIncomingFile do
  context 'association' do
    it { should have_one(:incoming_file) }
  end
end