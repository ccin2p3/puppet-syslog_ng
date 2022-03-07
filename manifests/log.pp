# Creates log paths in your configuration. It can create channels, junctions and reference already defined sources, destinations, etc. The syntax is a little bit different then the one previously described under statements.
#
# Here is a simple rule: if you want to reference an already defined type (e.g. s_gsoc2014) use a hash with one key-value pair. The key must be the type of the statement (e.g. source) and the value must be its title.
#
# If you do not specify a reference, use an array instead. Take a look at the example below:
#
# ```puppet
# syslog_ng::log { 'l2':
#   params => [
#     { 'source' => 's_gsoc2014' },
#     {
#       'junction' => [
#         {
#           'channel' => [
#             { 'filter' => 'f_json' },
#             { 'parser' => 'p_json' },
#           ],
#         },
#         {
#           'channel' => [
#             { 'filter' => 'f_not_json' },
#             { 'flags' => 'final' },
#           ],
#         },
#       ],
#     },
#     { 'destination' => 'd_gsoc' },
#   ],
# }
# ```
#
# @param params
#   The syntax is a bit different, but you can find examples under the tests directory.
define syslog_ng::log (
  Data $params = [],
) {
  $order = '80'
  concat::fragment { "syslog_ng::log ${title}":
    target  => $syslog_ng::config_file,
    content => syslog_ng::generate_log($params),
    order   => $order,
  }
}
