#
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
