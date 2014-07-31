require 'spec_helper'

describe 'mcollective::actionpolicy::base' do
  let (:title) { 'bar' }
  let (:facts) { {
    :id              => 'root',
    :kernel          => 'Linux',
    :lsbdistid       => 'Debian',
    :operatingsystem => 'Debian',
    :osfamily        => 'Debian',
    :path            => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    :clientcert      => 'foo.example.com',
  } }

  context 'when using a wrong ensure value' do
    let (:params) { {
      :ensure => 'running'
    } }

    it 'should fail' do
      expect { should contain_concat('/etc/mcollective/policies/bar.policy')
      }.to raise_error(Puppet::Error, /\$ensure must be either.* got 'running'/)
    end
  end

  context 'when default_policy is wrong' do
    let (:params) { {
      :default_policy => 'accept'
    } }

    it 'should fail' do
      expect { should contain_concat('/etc/mcollective/policies/bar.policy')
      }.to raise_error(Puppet::Error, /\$default_policy must be either.* got 'accept'/)
    end
  end

  context 'when using defaults' do
    it { should contain_concat('/etc/mcollective/policies/bar.policy').with(
      :owner => 'root',
      :group => 'root',
      :mode  => '0640'
    ) }

    it { should contain_concat__fragment('mcollective.actionpolicy.bar.base').with(
      :ensure  => :present,
      :order   => '00',
      :target  => '/etc/mcollective/policies/bar.policy',
      :content => "policy default deny\n"
    ) }
  end

  context 'when specifying policy' do
    let (:params) { {
      :default_policy => 'allow'
    } }

    it { should contain_concat__fragment('mcollective.actionpolicy.bar.base').with(
      :ensure  => :present,
      :order   => '00',
      :target  => '/etc/mcollective/policies/bar.policy',
      :content => "policy default allow\n"
    ) }
  end

end

