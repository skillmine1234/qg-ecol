require 'spec_helper'

describe EcolIncomingFile do
  context 'association' do
    it { should have_one(:incoming_file) }
  end
end