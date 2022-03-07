#
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
