require 'spec_helper'

describe 'trusted_ca::ca' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }
        let(:title) { 'mycert' }
        let(:pre_condition) { 'include trusted_ca' }
        let(:params) { { :source => 'puppet:///data/mycert.crt' } }

        context 'validations' do
          context 'bad source' do
            let(:params) { { :source => 'foo' } }
            it { expect { should create_define('trusted_ca::ca') }.to raise_error }
          end

          context 'bad content' do
            let(:params) { { :source => Nil, :content => 'foo' } }
            it { expect { should create_define('trusted_ca::ca') }.to raise_error }
          end

          context 'specifying both source and content' do
            let(:params) { { :content => 'foo' } }
            it { expect { should create_define('trusted_ca::ca') }.to raise_error }
          end

          context 'specifying neither source nor content' do
            let(:params) { { :content => Nil, :source => Nil } }
            it { expect { should create_define('trusted_ca::ca') }.to raise_error }
          end

          context 'not including trusted_ca' do
            let(:pre_condition) {}
            it { expect { should create_define('trusted_ca::ca') }.to raise_error }
          end
        end

        context "ca cert" do
          let(:params) { { :source => 'puppet:///data/mycert.crt' } }
          case facts[:osfamily]
          when "RedHat"
            file = '/etc/pki/ca-trust/source/anchors/mycert.crt'
            notify = 'Exec[validate /etc/pki/ca-trust/source/anchors/mycert.crt]'
          when "Debian"
            file = '/usr/local/share/ca-certificates/mycert.crt'
            notify = 'Exec[validate /usr/local/share/ca-certificates/mycert.crt]'
          when "Suse"
            let(:params) { { :source => 'puppet:///data/mycert.pem' } }
            if facts[:operatingsystem] == 'SLES'
              file = '/etc/ssl/certs/mycert.pem'
              notify = 'Exec[validate /etc/ssl/certs/mycert.pem]'
            else
              file = '/etc/pki/trust/anchors/mycert.pem'
              notify = 'Exec[validate /etc/pki/trust/anchors/mycert.pem]'
            end
          end
          it { should contain_file(file).with(:notify => notify) }
        end
      end
    end
  end
end
