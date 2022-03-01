# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'syslog_ng class' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      if fact('os.family') == 'debian' {
        # FIXME: https://github.com/puppetlabs/puppetlabs-apt/pull/1015
        ensure_packages('apt-transport-https')
        Package['apt-transport-https'] -> Class['apt::update']
      }

      if fact('os.family') == 'RedHat' {
        class { 'epel':
        }
        Class['epel'] -> Class['syslog_ng']
      }

      class { 'syslog_ng':
        manage_repo => true,
      }

      syslog_ng::config { 'version':
        content => '@version: 3.30',
        order   => '02',
      }
      PUPPET
    end
  end

  Dir[File.join(__dir__, '..', '..', 'examples', 'OK_*.pp')].each do |f|
    example = File.basename(f)
    context "Example #{example}" do
      it_behaves_like 'the example', example
    end
  end

  Dir[File.join(__dir__, '..', '..', 'examples', 'NOK_*.pp')].each do |f|
    example = File.basename(f)
    context "Example #{example}" do
      it { is_expected.to compile.and_raise_error }
    end
  end
end
