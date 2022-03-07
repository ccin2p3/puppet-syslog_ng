#
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
