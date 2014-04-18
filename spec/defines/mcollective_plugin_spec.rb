require 'spec_helper'

describe 'mcollective::plugin' do
  let (:title) { 'foo' }

  context 'when on Debian' do
    let (:facts) { {
      :id              => 'root',
      :kernel          => 'Linux',
      :operatingsystem => 'Debian',
      :osfamily        => 'Debian',
      :path            => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    } }

    it { should contain_package('mcollective-agent-foo').with(
      :ensure => :present
    ) }
  end

  context 'when on RedHat' do
    let (:facts) { {
      :id              => 'root',
      :kernel          => 'Linux',
      :operatingsystem => 'RedHat',
      :osfamily        => 'RedHat',
      :path            => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    } }

    it { should contain_package('mcollective-plugins-foo').with(
      :ensure => :present
    ) }
  end
end
