# Creates a destination in your configuration.
#
# ```puppet
# syslog_ng::destination { 'd_udp':
#   params => {
#     'type' => 'udp',
#     'options' => [
#       "'127.0.0.1'",
#       { 'port' => '1999' },
#       { 'localport' => '999' },
#     ],
#   },
# }
#
# @param params
#   An array of hashes or a single hash.
define syslog_ng::destination (
  Data $params = [],
) {
  $type = 'destination'
  $id = $title
  $order = '70'

  concat::fragment { "syslog_ng::destination ${title}":
    target  => $syslog_ng::config_file,
    content => syslog_ng::generate_statement($id, $type, $params),
    order   => $order,
  }
}
