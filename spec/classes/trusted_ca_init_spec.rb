require 'spec_helper'

describe 'trusted_ca' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        context 'ca-certificates' do
          if facts[:osfamily] == 'Suse' && facts[:operatingsystem] == 'SLES' && facts[:operatingsystemmajrelease] == '11'
            package_name = 'openssl-certs'
          else
            package_name = 'ca-certificates'
          end

          context 'default' do
            it { should contain_package(package_name).with(:ensure => 'latest') }
          end

          context 'set version' do
            let(:params) { { :certificates_version => '1.2.3.4' } }
            it { should contain_package(package_name).with(:ensure => '1.2.3.4') }
          end
        end

        context 'update_system_certs' do
          context 'array path' do
            let(:params) { { :path => ['/bin', '/usr/bin'] } }
            it { should contain_exec('update_system_certs').with(:refreshonly => true, :path => ['/bin', '/usr/bin']) }
          end

          context 'string path' do
            let(:params) { { :path => '/usr/bin' } }
            it { should contain_exec('update_system_certs').with( :refreshonly => true, :path => '/usr/bin') }
          end
        end

        context 'fail on unsupported system' do
          let(:facs) { { :osfamily => 'FreeBSD', :operatingsystemrelease => '1.2.3' } }
          it { expect { should create_class('trusted_ca').to raise_error } }
        end
      end
    end
  end
end
