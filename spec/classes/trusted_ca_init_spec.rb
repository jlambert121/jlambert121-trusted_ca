require 'spec_helper'

describe 'trusted_ca', :type => :class do

  it { should create_class('trusted_ca') }
  it { should contain_package('ca-certificates') }

end

