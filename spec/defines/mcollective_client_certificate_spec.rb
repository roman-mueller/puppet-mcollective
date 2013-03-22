require 'spec_helper'

describe 'mcollective::client::certificate' do
  let (:title) { 'johndoe' }
  let (:facts) { {
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian'
  } }

  context 'when no key is passed' do
    it 'should fail' do
      expect { should contain_file('/etc/mcollective/ssl/clients/johndoe.pem')
      }.to raise_error(Puppet::Error, /You must pass either \$key_source or \$key_source_dir/)
    end
  end

  context 'when both key_source and key_source_dir are passed' do
    let (:params) { {
      :key_source     => '/tmp/johndoe.pem',
      :key_source_dir => '/tmp/keys'
    } }

    it 'should fail' do
      expect { should contain_file('/etc/mcollective/ssl/clients/johndoe.pem')
      }.to raise_error(Puppet::Error, /You must pass either \$key_source or \$key_source_dir/)
    end
  end


  context 'when a wrong ensure passed' do
    let (:params) { {
      :key_source => '/tmp/johndoe.pem',
      :ensure     => 'running'
    } }

    it 'should fail' do
      expect { should contain_file('/etc/mcollective/ssl/clients/johndoe.pem')
      }.to raise_error(Puppet::Error, /\$ensure must be either.* got 'running'/)
    end
  end

  context 'when specifying key_source' do
    let (:params) { {
      :key_source => '/tmp/johndoe.pem'
    } }

    it { should contain_file('/etc/mcollective/ssl/clients/johndoe.pem').with(
      :ensure => 'present',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0640',
      :source => '/tmp/johndoe.pem'
    ) }
  end

  context 'when specifying key_source_dir' do
    let (:params) { {
      :key_source_dir => '/tmp/keys'
    } }

    it { should contain_file('/etc/mcollective/ssl/clients/johndoe.pem').with(
      :ensure => 'present',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0640',
      :source => '/tmp/keys/johndoe.pem'
    ) }
  end
end
