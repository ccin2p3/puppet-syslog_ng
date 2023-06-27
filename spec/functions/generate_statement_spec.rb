# frozen_string_literal: true

require 'spec_helper'

describe 'syslog_ng::generate_statement' do
  let(:title) { 'r_name' }
  let(:type) { 'rewrite' }
  let(:param1_expected) do
    <<~EOT
      rewrite r_name {
          subst(
              'string',
              'replacement',
              value(
                  field
              ),
              flags(
              )
          );
      };
    EOT
  end

  context 'Array notation with one item can be omitted' do
    let(:param1) do
      {
        'type' => 'subst',
        'options' => [
          "'string'",
          "'replacement'",
          { 'value' => 'field' },
          { 'flags' => '' }
        ]
      }
    end

    it 'On parameters of options' do
      is_expected.to run.with_params(title, type, [param1]).and_return(param1_expected)
    end

    it 'On options' do
      is_expected.to run.with_params(title, type, param1).and_return(param1_expected)
    end
  end

  context 'Type and options key can be reduced to the exact type of statement' do
    let(:param1) do
      {
        'subst' => [
          "'string'",
          "'replacement'",
          { 'value' => 'field' },
          { 'flags' => '' }
        ]
      }
    end

    it 'On parameters of options' do
      is_expected.to run.with_params(title, type, [param1]).and_return(param1_expected)
    end

    it 'On options' do
      is_expected.to run.with_params(title, type, param1).and_return(param1_expected)
    end
  end

  context 'Array notation with one item and flags can be omitted' do
    let(:param2) do
      {
        'type' => 'subst',
        'options' => [
          "'string'",
          "'replacement'",
          { 'value' => 'field' },
          { 'flags' => 'ignore-case, store-matches' }
        ]
      }
    end
    let(:param2_expected) do
      <<~EOT
        rewrite r_name {
            subst(
                'string',
                'replacement',
                value(
                    field
                ),
                flags(
                    ignore-case, store-matches
                )
            );
        };
      EOT
    end

    it 'On parameters of options' do
      is_expected.to run.with_params(title, type, [param2]).and_return(param2_expected)
    end

    it 'On options' do
      is_expected.to run.with_params(title, type, param2).and_return(param2_expected)
    end
  end

  context 'With simple options' do
    let(:param1) do
      {
        'type' => 'subst',
        'options' => [
          "'string'",
          "'replacement'",
          { 'value' => ['field'] },
          { 'flags' => [] }
        ]
      }
    end

    let(:params) { [param1] }

    it 'generates rewrite rule' do
      is_expected.to run.with_params(title, type, param1).and_return(param1_expected)
    end
  end

  context 'Array statement' do
    let(:type) { 'source' }
    let(:title) { 's_external' }
    let(:params) do
      [
        { 'type' => 'udp',
          'options' => [
            { 'ip' => ["'192.168.42.2'"] },
            { 'port' => [514] },
            { 'tls' => [
              { 'key_file' => ['"/opt/syslog-ng/etc/syslog-ng/key.d/syslog-ng.key"'] },
              { 'cert_file' => '"/opt/syslog-ng/etc/syslog-ng/cert.d/syslog-ng.cert"' },
              { 'peer_verify' => 'optional-untrusted' }
            ] }
          ] },
        { 'type' => 'tcp',
          'options' => [
            { 'ip' => ["'192.168.42.2'"] },
            { 'port' => [514] }
          ] },
        {
          'type' => 'syslog',
          'options' => [
            { 'flags' => %w[no-multi-line no-parse] },
            { 'ip' => ["'10.65.0.5'"] },
            { 'keep-alive' => ['yes'] },
            { 'keep_hostname' => ['yes'] },
            { 'transport' => ['udp'] }
          ]
        }
      ]
    end
    let(:expected) do
      <<~EOT
        source s_external {
            udp(
                ip(
                    '192.168.42.2'
                ),
                port(
                    514
                ),
                tls(
                    key_file(
                        "/opt/syslog-ng/etc/syslog-ng/key.d/syslog-ng.key"
                    ),
                    cert_file(
                        "/opt/syslog-ng/etc/syslog-ng/cert.d/syslog-ng.cert"
                    ),
                    peer_verify(
                        optional-untrusted
                    )
                )
            );
            tcp(
                ip(
                    '192.168.42.2'
                ),
                port(
                    514
                )
            );
            syslog(
                flags(
                    no-multi-line,
                    no-parse
                ),
                ip(
                    '10.65.0.5'
                ),
                keep-alive(
                    yes
                ),
                keep_hostname(
                    yes
                ),
                transport(
                    udp
                )
            );
        };
      EOT
    end

    it 'generates source rule' do
      is_expected.to run.with_params(title, type, params).and_return(expected)
    end
  end
end
