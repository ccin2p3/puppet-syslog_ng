# frozen_string_literal: true

if RUBY_VERSION >= '1.9.2'
  require_relative 'statement'
else
  require File.join(__dir__, './statement')
end

describe 'syslog_ng::rewrite' do
  it_behaves_like 'Statement', 'id', 'rewrite'
end
