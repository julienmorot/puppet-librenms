require 'spec_helper'
describe 'librenms' do
  context 'with default values for all parameters' do
    it { should contain_class('librenms') }
  end
end
