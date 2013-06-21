require 'spec_helper'

describe 'trusted_ca', :type => :class do
  let (:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }

  it { should create_class('trusted_ca') }
  it { should contain_package('ca-certificates') }
  it { should contain_concat('/etc/pki/tls/certs/ca-bundle.crt') }
  it { should contain_concat__fragment('ca-bundle.crt-base') }

  context 'allow package version' do
    let(:params) { { :version => '1.2.3' } }

    it { should contain_package('ca-certificates').with_ensure('1.2.3') }
  end

  context 'allow crt base source change' do
    let(:params) { { :ca_base => 'puppet:///data/ca-bundle.crt' } }

    it { should contain_concat__fragment('ca-bundle.crt-base').with_source('puppet:///data/ca-bundle.crt') }
  end

end

