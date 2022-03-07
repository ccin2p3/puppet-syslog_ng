# Creates one or more rewrite rules in your configuration.
#
# ```puppet
# syslog_ng::rewrite{ 'r_rewrite_subst':
#   params => {
#     'type' => 'subst',
#     'options' => [
#       '"IP"',
#       '"IP-Address"',
#       { 'value' => '"MESSAGE"' },
#       { 'flags' => 'global' },
#     ],
#   },
# }
# ```
#
# @param params
#   An array of hashes or a single hash.
define syslog_ng::rewrite (
  Data $params = [],
) {
  $type = 'rewrite'
  $id = $title
  $order = '30'

  concat::fragment { "syslog_ng::rewrite ${title}":
    target  => $syslog_ng::config_file,
    content => syslog_ng::generate_statement($id, $type, $params),
    order   => $order,
  }
}
