# @summary Add global options
#
# Creates a global options statement. Currently it is not a class, so you should not declare it multiple times! It is not defined as a class, so you can declare it as other similar types.
#
# ```puppet
# syslog_ng::options { "global_options":
#   options => {
#     'bad_hostname' => "'no'",
#     'time_reopen'  => 10,
#   },
# }
# ```
#
# @param options
#   A hash containing string keys and string values. In the generated configuration the keys will appear in alphabetical order.
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
