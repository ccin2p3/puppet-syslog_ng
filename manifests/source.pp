# Creates a source in your configuration.
#
# ```puppet
# syslog_ng::source { 's_gsoc':
#   params => {
#     'type'    => 'tcp',
#     'options' => [
#       { 'ip' => "'127.0.0.1'" },
#       { 'port' => 1999 },
#     ],
#   },
# }
#
# syslog_ng::source { 's_external':
#   params => [
#     {
#       'type'    => 'udp',
#       'options' => [
#         { 'ip' => ["'127.0.0.1'"] },
#         { 'port' => [514] },
#       ],
#     },
#     {
#       'type'    => 'tcp',
#       'options' => [
#         { 'ip' => ["'127.0.0.1'"] },
#         { 'port' => [514] },
#       ],
#     },
#     {
#       'type'    => 'syslog',
#       'options' => [
#         { 'flags' => ['no-multi-line', 'no-parse'] },
#         { 'ip' => ["'127.0.0.1'"] },
#         { 'keep-alive' => ['yes'] },
#         { 'keep_hostname' => ['yes'] },
#         { 'transport' => ['udp'] },
#       ],
#     },
#   ],
# }
# ```
#
# @param params
#   An array of hashes or a single hash.
define syslog_ng::source (
  Data $params = [],
) {
  include syslog_ng

  $type = 'source'
  $id = $title
  $order = '60'

  concat::fragment { "syslog_ng::source ${title}":
    target  => $syslog_ng::config_file,
    content => syslog_ng::generate_statement($id, $type, $params),
    order   => $order,
  }
}
