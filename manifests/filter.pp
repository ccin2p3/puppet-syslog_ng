# Creates a filter in your configuration. **It does not support binary operators, such as `and` or `or`**. Please, use a `syslog_ng::config` if you need this functionality.
#
# ```puppet
# syslog_ng::filter { 'f_tag_filter':
#   params => {
#     'type' => 'tags',
#     'options' => [
#       '".classifier.system"',
#     ],
#   },
# }
# ```
#
# @param params
#   An array of hashes or a single hash.
define syslog_ng::filter (
  Data $params = [],
) {
  $type = 'filter'
  $id = $title
  $order = '50'

  concat::fragment { "syslog_ng::filter ${title}":
    target  => $syslog_ng::config_file,
    content => syslog_ng::generate_statement($id, $type, $params),
    order   => $order,
  }
}
