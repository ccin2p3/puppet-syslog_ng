# frozen_string_literal: true

require 'spec_helper'

describe 'syslog_ng' do
  let(:facts) do
    { concat_basedir: '/dne',
      osfamily: 'Debian',
      os: { family: 'Debian', name: 'Ubuntu', release: { full: '14.04', major: '14.04' }, distro: { codename: 'trusty' } },
      operatingsystem: 'Ubuntu' }
  end

  context 'With not default params' do
    let(:params) do
      {
        config_file: '/tmp/puppet-test/syslog-ng.conf',
        sbin_path: '/home/tibi/install/syslog-ng',
        manage_init_defaults: true
      }
    end

    it {
      is_expected.to contain_package('syslog-ng-core')
      is_expected.to contain_service('syslog-ng')
    }

    it {
      is_expected.to contain_file('/etc/default/syslog-ng')
    }
  end

  context 'with unofficial repo' do
    let(:params) do
      {
        manage_repo: true,
      }
    end

    it { is_expected.to compile }
    it { is_expected.to contain_apt__source('syslog-ng-obs') }
  end

  context 'On RedHat' do
    let(:facts) do
      { concat_basedir: '/dne',
        osfamily: 'RedHat',
        os: { family: 'RedHat', name: 'RedHat', release: { major: '7' } },
        operatingsystem: 'RedHat' }
    end

    context 'with init_defaults set to true' do
      let(:params) do
        {
          manage_init_defaults: true
        }
      end

      it {
        is_expected.to contain_package('syslog-ng')
        is_expected.to contain_service('syslog-ng')
      }

      it {
        is_expected.to contain_file('/etc/sysconfig/syslog-ng')
      }
    end

    context 'with unofficial repo' do
      let(:params) do
        {
          manage_repo: true,
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_yumrepo('czanik-syslog-ng-githead') }
    end
  end

  context 'On SLES with init_defaults set to true' do
    let(:params) do
      {
        manage_init_defaults: true
      }
    end
    let(:facts) do
      { concat_basedir: '/dne',
        osfamily: 'Suse',
        os: { family: 'Suse' },
        operatingsystem: 'SLES' }
    end

    it {
      is_expected.to contain_package('syslog-ng')
      is_expected.to contain_service('syslog-ng')
    }

    it {
      is_expected.to contain_file('/etc/sysconfig/syslog-ng')
    }
  end

  context 'When asked not to manage package' do
    let(:params) do
      {
        manage_package: false
      }
    end

    it { is_expected.not_to contain_package('syslog-ng-core') }
  end

  context 'When asked to use additional module' do
    let(:params) do
      {
        modules: ['foo', 'bar', 'baz']
      }
    end

    it {
      is_expected.to contain_syslog_ng__module('foo')
      is_expected.to contain_syslog_ng__module('bar')
      is_expected.to contain_syslog_ng__module('baz')
    }
  end

  context 'When config changes' do
    it {
      is_expected.to contain_concat('/etc/syslog-ng/syslog-ng.conf').that_notifies('Exec[syslog_ng_reload]')
    }

    context 'and asked to check syntax before reload' do
      let(:params) do
        {
          syntax_check_before_reloads: true
        }
      end

      it {
        is_expected.to contain_concat('/etc/syslog-ng/syslog-ng.conf').with_validate_cmd(%r{syntax-only})
      }
    end

    context 'and asked not to check syntax before reload' do
      let(:params) do
        {
          syntax_check_before_reloads: false
        }
      end

      it {
        is_expected.to contain_concat('/etc/syslog-ng/syslog-ng.conf').without_validate_cmd
      }
    end
  end
end
