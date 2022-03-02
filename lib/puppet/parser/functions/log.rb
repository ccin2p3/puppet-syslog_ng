# frozen_string_literal: true

require 'stringio'

module Log
  def self.build_reference(key, value, indent, buffer)
    buffer << "#{indent}#{key}(#{value});\n"
  end

  def self.build_array(array, indent, buffer)
    array.each do |item|
      build(item, indent, buffer) if item.is_a? Hash
    end
  end

  def self.build(hash, indent, buffer)
    indent += '    '
    return 'Error' if hash.keys.length != 1

    key = hash.keys[0]

    value = hash[key]

    case value
    when String
      build_reference(key, value, indent, buffer)
    when Array
      buffer << "#{indent}#{key} {\n"
      build_array(value, indent, buffer)
      buffer << "#{indent}};\n"
    when Hash
      buffer << "#{indent}Build error\n"
    end
  end

  def self.generate_log(options)
    buffer = StringIO.new
    indent = ''
    buffer << "log {\n"
    build_array(options, indent, buffer)
    buffer << "};\n"
    buffer.string
  end
end
