class { 'syslog_ng':
  config_file                 => '/tmp/syslog-ng.conf',
  manage_package              => false,
  syntax_check_before_reloads => true,
  user                        => 'balabit',
  group                       => 'balabit',
  manage_init_defaults        => false,
}

# Should fail with:
#    Error parsing config, syntax error, unexpected LL_ERROR, expecting end of file

syslog_ng::config { 'version':
  content => '@version 3.6',
  order   => '02',
}
