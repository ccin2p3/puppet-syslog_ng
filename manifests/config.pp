# Some elements of the syslog-ng DSL are not supported by this module (mostly the boolean operators in filters) so you may want to keep some configuration snippets in their original form. This type lets you write texts into the configuration without any parsing or processing.
#
# Every configuration file begins with a @version: <version> line. You can use this type to write this line into the configuration, make comments or use existing snippets.
#
# ```puppet
# syslog_ng::config {'version':
#    content => '@version: 3.6',
#    order => '02'
# }
# ```
#
# @param content
#   Configures the text which must be written into the configuration file. A newline character is automatically appended to its end.
# @param order
#   Sets the order of this snippet in the configuration file. If you want to write the version line, the `order => '02'` is suggested, because the auto generated header has order '01'.
define syslog_ng::config (
  String[1] $content,
  String[1] $order = '5',
) {
  concat::fragment { "syslog_ng::config ${title}":
    target  => $syslog_ng::config_file,
    content => "${content}\n",
    order   => $order,
  }
}
