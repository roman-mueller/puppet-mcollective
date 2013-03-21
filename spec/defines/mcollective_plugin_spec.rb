require 'spec_helper'

describe 'mcollective::plugin' do
  let (:title) { 'foo' }

  context 'when on Debian' do
    let (:facts) { {
      :osfamily        => 'Debian',
      :operatingsystem => 'Debian'
    } }

    it { should contain_package('mcollective-agent-foo').with(
      :ensure => :present
    ) }
  end

  context 'when on RedHat' do
    let (:facts) { {
      :osfamily        => 'RedHat',
      :operatingsystem => 'RedHat'
    } }

    it { should contain_package('mcollective-plugins-foo').with(
      :ensure => :present
    ) }
  end
end
