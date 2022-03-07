# frozen_string_literal: true

require 'spec_helper'

describe 'syslog_ng::generate_log' do
  context 'With simple options' do
    let(:title) { 's_gsoc' }
    let(:options) do
      [
        { 'source' => 's_gsoc2014' },
        { 'destination' => 'd_gsoc' }
      ]
    end
    let(:expected) do
      <<~EOT
        log {
            source(s_gsoc2014);
            destination(d_gsoc);
        };
      EOT
    end

    it 'generates a flat log' do
      is_expected.to run.with_params(options).and_return(expected)
    end
  end

  context 'With complex options' do
    let(:title) { 's_gsoc' }
    let(:options) do
      [
        { 'source' => 's_gsoc2014' },
        { 'junction' => [
          {
            'channel' => [
              { 'filter' => 'f_json' },
              { 'parser' => 'p_json' }
            ]
          },
          {
            'channel' => [
              { 'filter' => 'f_not_json' },
              { 'flags' => 'final' }
            ]
          }
        ] },
        { 'destination' => 'd_gsoc' }
      ]
    end
    let(:expected) do
      <<~EOT
        log {
            source(s_gsoc2014);
            junction {
                channel {
                    filter(f_json);
                    parser(p_json);
                };
                channel {
                    filter(f_not_json);
                    flags(final);
                };
            };
            destination(d_gsoc);
        };
      EOT
    end

    it 'generates a complex log' do
      is_expected.to run.with_params(options).and_return(expected)
    end
  end
end
