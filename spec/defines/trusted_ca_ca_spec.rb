require 'spec_helper'

describe 'trusted_ca::ca', :type => :define do
  let(:title) { 'mycert' }
  let(:pre_condition) { 'include trusted_ca' }
  let(:params) { { :source => 'puppet:///data/mycert.crt' } }

  context 'validations' do
    let(:facts) { { :osfamily => 'RedHat', :operatingsystemmajrelease => '6' } }

    context 'bad source' do
      let(:params) { { :source => 'foo' } }
      it { expect { should create_define('trusted_ca::ca') }.to raise_error }
    end

    context 'not including trusted_ca' do
      let(:pre_condition) {}
      it { expect { should create_define('trusted_ca::ca') }.to raise_error }
    end
  end

  context 'on RedHat' do
    let(:facts) { { :osfamily => 'RedHat', :operatingsystemmajrelease => '6' } }

    context 'default' do
      it { should contain_file('/etc/pki/ca-trust/source/anchors/mycert.crt').with(
        :source => 'puppet:///data/mycert.crt',
        :notify => "Exec[update_system_certs]"
      ) }
    end

  end

  context 'on Ubuntu' do
    let(:facts) { { :osfamily => 'Debian', :operatingsystemrelease => '12.04' } }

    context 'default' do
      it { should contain_file('/usr/local/share/ca-certificates/mycert.crt').with(
        :source => 'puppet:///data/mycert.crt',
        :notify => "Exec[update_system_certs]"
      ) }
    end
  end

end

