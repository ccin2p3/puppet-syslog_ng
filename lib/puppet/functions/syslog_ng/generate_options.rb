# frozen_string_literal: true

require 'stringio'

# Generate options
Puppet::Functions.create_function(:'syslog_ng::generate_options') do
  # @param options
  # @return [String] The generated options
  dispatch :generate_options do
    param 'Hash[String[1], Variant[Integer, String]]', :options
  end

  def generate_options(options)
    buffer = StringIO.new
    buffer << "options {\n"
    indent = '    '

    return '' if options.empty?

    options.keys.sort.each do |option|
      value = options[option]
      buffer << indent
      buffer << option
      buffer << '('
      buffer << value
      buffer << ");\n"
    end
    buffer << "};\n"
    buffer.string
  end
end
