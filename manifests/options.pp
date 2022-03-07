#
define syslog_ng::options (
  Hash $options = {},
) {
  $order = '10'

  concat::fragment { "syslog_ng::options ${title}":
    target  => $syslog_ng::config_file,
    content => syslog_ng::generate_options($options),
    order   => $order,
  }
}
