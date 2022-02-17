# Copyright 2014 Tibor Benke

class syslog_ng (
  Stdlib::Absolutepath $config_file,
  String[1] $package_name,
  String[1] $service_name,
  String[1] $module_prefix,
  Stdlib::Absolutepath $init_config_file,
  Hash $init_config_hash,
  String[1] $config_file_header,
  String[1] $package_ensure,
  Boolean $manage_init_defaults        = false,
  Boolean $manage_repo                 = false,
  Boolean $manage_package              = true,
  Array[String[1]] $modules            = [],
  Stdlib::Absolutepath $sbin_path      = '/usr/sbin',
  String[1] $user                      = 'root',
  String[1] $group                     = 'root',
  Boolean $syntax_check_before_reloads = true,
) {
  if ($manage_package) {
    include syslog_ng::repo

    package { $package_name:
      ensure => $package_ensure,
      before => [
        Concat[$config_file],
        Exec['syslog_ng_reload'],
      ],
    }
    syslog_ng::module { $modules: }
  }

  @concat { $config_file:
    ensure         => present,
    path           => $config_file,
    owner          => $user,
    group          => $group,
    warn           => true,
    ensure_newline => true,
  }

  class { 'syslog_ng::reload':
    syntax_check_before_reloads => $syntax_check_before_reloads,
  }

  concat::fragment { 'syslog_ng header':
    target  => $config_file,
    content => $config_file_header,
    order   => '01',
  }

  if $manage_init_defaults {
    $merged_init_config_hash = merge($init_config_hash,$init_config_hash)
    file { $init_config_file:
      ensure  => file,
      content => template('syslog_ng/init_config_file.erb'),
      notify  => Exec['syslog_ng_reload'],
    }
  }

  service { $service_name:
    ensure  => running,
    enable  => true,
    require => Concat[$config_file],
  }
}
