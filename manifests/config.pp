#
define syslog_ng::config (
  String[1] $content,
  String[1] $order = '5',
) {
  concat::fragment { "syslog_ng::config ${title}":
    target  => $syslog_ng::config_file,
    content => "${content}\n",
    order   => $order,
  }
}
