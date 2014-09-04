require 'spec_helper'
describe 'winbind' do

  context 'with defaults for all parameters' do
    it { should contain_class('winbind') }
  end
end
