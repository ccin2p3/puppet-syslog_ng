# Creates one or more templates in your configuration.
#
# ```puppet
# syslog_ng::template {'t_demo_filetemplate':
#   params => [
#     {
#       'type'    => 'template',
#       'options' => [
#         '"$ISODATE $HOST $MSG\n"',
#       ],
#     },
#     {
#       'type'    => 'template_escape',
#       'options' => [
#         'no',
#       ],
#     },
#   ],
# }
# ```
#
# @param params
#   An array of hashes or a single hash.
define syslog_ng::template (
  Data $params = [],
) {
  $type = 'template'
  $id = $title
  $order = '20'

  concat::fragment { "syslog_ng::template ${title}":
    target  => $syslog_ng::config_file,
    content => syslog_ng::generate_statement($id, $type, $params),
    order   => $order,
  }
}
