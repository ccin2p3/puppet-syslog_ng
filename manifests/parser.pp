# Creates a parser statement in your configuration.
#
# ```puppet
# syslog_ng::parser { 'p_hostname_segmentation':
#   params => {
#     'type' => 'csv-parser',
#     'options' => [
#       {
#         'columns' => [
#           '"HOSTNAME.NAME"',
#           '"HOSTNAME.ID"',
#         ],
#       },
#       {'delimiters' => '"-"'},
#       {'flags' => 'escape-none'},
#       {'template' => '"${HOST}"'},
#     ],
#   },
# }
# ```
#
# @param params
#   An array of hashes or a single hash.
define syslog_ng::parser (
  Data $params = [],
) {
  $type = 'parser'
  $id = $title
  $order = '40'

  concat::fragment { "syslog_ng::parser ${title}":
    target  => $syslog_ng::config_file,
    content => syslog_ng::generate_statement($id, $type, $params),
    order   => $order,
  }
}
