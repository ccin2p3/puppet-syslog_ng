require 'spec_helper'

describe 'generate_options' do
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
      result = scope.function_generate_options([params])
      expect(result).to be_a String
      expect(result).to eq expected
    end
  end

  context 'Without options' do
    it 'generates nothing' do
      result = scope.function_generate_options([{}])
      expect(result).to be_a String
      expect(result).to eq ''
    end
  end
end
