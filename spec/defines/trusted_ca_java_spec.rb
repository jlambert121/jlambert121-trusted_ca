require 'spec_helper'

describe 'trusted_ca::java', :type => :define do
  let(:title) { 'mycert' }
  let(:params) { {
    :source => 'puppet:///data/mycert.crt',
    :java_keystore => '/etc/alternatives/jre_1.7.0/lib/security/cacerts'
  } }

  it { should contain_file('/tmp/mycert-trustedca') }
  it { should contain_exec('import mycert to java').with(
    :command => 'keytool -import -noprompt -trustcacerts -alias mycert -file /tmp/mycert-trustedca -keystore /etc/alternatives/jre_1.7.0/lib/security/cacerts -storepass changeit'
  )}

end
