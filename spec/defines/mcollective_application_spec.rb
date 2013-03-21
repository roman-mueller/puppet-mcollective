require 'spec_helper'

describe 'mcollective::application' do
  let (:title) { 'foo' }
  let (:facts) { {
    :osfamily => 'RedHat',
    :operatingsystem => 'RedHat',
  } }

  context 'when no source is passed' do
    it { should contain_file('/usr/libexec/mcollective/mcollective/application/foo.rb').with(
        :ensure => :present,
        :source => 'puppet:///modules/mcollective/application/foo.rb'
      ) }
  end
end
