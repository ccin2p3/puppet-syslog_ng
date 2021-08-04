require 'stringio'

module Puppet::Parser::Functions
  newfunction(:generate_options, type: :rvalue) do |args|
    options = args[0]
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
