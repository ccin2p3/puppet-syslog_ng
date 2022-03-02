#
define syslog_ng::log (
  Data $params = [],
) {
  $order = '80'
  concat::fragment { "syslog_ng::log ${title}":
    target  => $syslog_ng::config_file,
    content => generate_log($params),
    order   => $order,
  }
}
