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
      :clientcert      => 'foo.example.com',
    } }

    it { should contain_package('mcollective-agent-foo').with(
      :ensure => :present
    ) }
  end

  context 'when on RedHat' do
    let (:facts) { {
      :id                        => 'root',
      :kernel                    => 'Linux',
      :operatingsystem           => 'RedHat',
      :operatingsystemmajrelease => '7',
      :osfamily                  => 'RedHat',
      :path                      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      :clientcert                => 'foo.example.com',
    } }

    it { should contain_package('mcollective-plugins-foo').with(
      :ensure => :present
    ) }
  end

  context 'when using new names' do
    let (:facts) { {
      :id              => 'root',
      :kernel          => 'Linux',
      :operatingsystem => 'Debian',
      :osfamily        => 'Debian',
      :path            => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      :clientcert      => 'foo.example.com',
    } }

    let (:params) { {
      :old_names => false,
    } }

    it { should contain_package('mcollective-agent-foo').with_ensure('absent') }
    it { should contain_package('mcollective-foo-agent').with_ensure('present') }
  end

  context 'when setting type' do
    let (:facts) { {
      :id              => 'root',
      :kernel          => 'Linux',
      :operatingsystem => 'Debian',
      :osfamily        => 'Debian',
      :path            => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      :clientcert      => 'foo.example.com',
    } }

    let (:params) { {
      :old_names => false,
      :type      => 'client',
    } }

    it { should contain_package('mcollective-foo-client').with_ensure('present') }
  end
end
