require 'spec_helper'

describe 'trusted_ca::ca', :type => :define do
  let(:title) { 'my_ca' }

  context 'default (no java class)' do
    it { should contain_exec('import my_ca to ca-bundle.crt') }
    it { should_not contain_exec('import my_ca to java') }
  end

  context 'default (java class)' do
    let(:pre_condition) { ['class java {}', 'include java'] }

    it { should contain_exec('import my_ca to java') }
  end

  context 'when no source' do
    it { expect { should raise_error(Puppet::Error) } }
  end

  context 'accept source' do
    let(:params) { { :source => 'puppet:///data/myca.pem' } }

    it { should contain_file('/tmp/my_ca-trustedca').with_source('puppet:///data/myca.pem') }
  end

  context 'no system' do
    let(:pre_condition) { ['class java {}', 'include java'] }
    let(:params) { { :source => 'puppet:///test', :system => false } }

    it { should_not contain_exec('import my_ca to ca-bundle.crt') }
    it { should contain_exec('import my_ca to java') }
  end

  context 'no java' do
    let(:params) { { :source => 'puppet:///test', :java => false } }

    it { should contain_exec('import my_ca to ca-bundle.crt') }
    it { should_not contain_exec('import my_ca to java') }
  end

end
