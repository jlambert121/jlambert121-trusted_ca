require 'spec_helper'

describe 'trusted_ca::ca', :type => :define do
  let (:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }
  let(:title) { 'my_ca' }

  context 'when no source' do
    it { expect { should raise_error(Puppet::Error) } }
  end

  context 'accept source' do
    let(:params) { { :source => 'puppet:///data/myca.pem' } }

    it { should contain_concat__fragment('ca-bundle.crt-my_ca').with_source('puppet:///data/myca.pem') }
  end

  context 'accept content' do
    let(:params) { { :content => '-----BEGIN CERTIFICATE REQUEST-----' } }

    it { should contain_concat__fragment('ca-bundle.crt-my_ca').with_content('-----BEGIN CERTIFICATE REQUEST-----') }
  end

end
