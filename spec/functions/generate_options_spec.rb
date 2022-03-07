# frozen_string_literal: true

require 'spec_helper'

describe 'syslog_ng::generate_options' do
  context 'With options' do
    let(:params) do
      { 'log_fifo_size' => 2048,
        'create_dirs' => 'yes' }
    end
    let(:expected) do
      <<~EOT
        options {
            create_dirs(yes);
            log_fifo_size(2048);
        };
      EOT
    end

    it 'fills the options statement' do
      is_expected.to run.with_params(params).and_return(expected)
    end
  end

  context 'Without options' do
    it 'generates nothing' do
      is_expected.to run.with_params({}).and_return('')
    end
  end
end
