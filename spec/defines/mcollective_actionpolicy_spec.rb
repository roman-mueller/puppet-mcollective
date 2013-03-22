require 'spec_helper'

describe 'mcollective::actionpolicy' do
  let (:title) { 'cert=user@foo' }
  let (:facts) { {
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian'
  } }

  context 'when rpccaller contains spaces' do
    let (:params) { {
      :rpccaller => 'foo bar'
    } }

    it 'should fail' do
      expect { should contain_concat__fragment('mcollective.actionpolicy.foo.foo bar')
      }.to raise_error(Puppet::Error, /\$rpccaller must be.* got 'foo bar'/)
    end
  end

  context 'when agent is empty' do
    let (:title) { 'cert=user' }

    it 'should fail' do
      expect { should contain_concat__fragment('mcollective.actionpolicy..cert=user')
      }.to raise_error(Puppet::Error, /Wrong value for \$agent ''/)
    end
  end

  context 'when agent contains spaces' do
    let (:params) { {
      :agent => 'foo bar'
    } }

    it 'should fail' do
      expect { should contain_concat__fragment('mcollective.actionpolicy.foo bar.rule')
      }.to raise_error(Puppet::Error, /Wrong value for \$agent 'foo bar'/)
    end
  end

  context 'when agent is not declared' do
    let (:title) { 'cert=user@bar' }

    it 'should fail' do
      expect { should contain_concat__fragment('mcollective.actionpolicy.cert=user.bar')
      }.to raise_error(Puppet::Error, /You must declare an mcollective::actionpolicy::base for agent 'bar'/)
    end
  end

  context 'when auth has a wrong value' do
    let (:params) { {
      :auth => 'update'
    } }

    it 'should fail' do
      expect { should contain_concat__fragment('mcollective.actionpolicy.rule.bar')
      }.to raise_error(Puppet::Error, /\$auth must be either 'allow' or 'deny', got 'update'/)
    end
  end



end
