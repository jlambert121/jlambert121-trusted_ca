require 'spec_helper'

describe 'trusted_ca::ca', :type => :define do
  let (:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }
  let(:title) { 'my_ca' }

  context 'default' do
    it { should contain_concat__fragment('ca-bundle.crt-my_ca') }
    it { should contain_exec('import my_ca to java') }
  end

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

  context 'no system' do
    let(:params) { { :source => 'puppet:///test', :system => false } }

    it { should_not contain_concat__fragment('ca-bundle.crt-my_ca') }
    it { should contain_exec('import my_ca to java') }
  end

  context 'no java' do
    let(:params) { { :source => 'puppet:///test', :java => false } }

    it { should contain_concat__fragment('ca-bundle.crt-my_ca') }
    it { should_not contain_exec('import my_ca to java') }
  end

end
