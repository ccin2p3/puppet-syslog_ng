# Copyright 2014 Tibor Benke

class syslog_ng (
  $config_file          = $::syslog_ng::params::config_file,
  $tmp_config_file      = $::syslog_ng::params::tmp_config_file,
  $package_name         = $::syslog_ng::params::package_name,
  $service_name         = $::syslog_ng::params::service_name,
  $module_prefix        = $::syslog_ng::params::module_prefix,
  $manage_package       = true,
  $modules              = [],
  $sbin_path            = '/usr/sbin',
  $user                 = 'root',
  $group                = 'root',
  $syntax_check_before_reloads = true,
  $config_file_header   = $::syslog_ng::params::config_file_header,
) inherits syslog_ng::params {

  validate_bool($syntax_check_before_reloads)
  validate_bool($manage_package)
  validate_array($modules)

  class {'syslog_ng::reload':
    syntax_check_before_reloads => $syntax_check_before_reloads
  }

  if ($manage_package) {
    package { $::syslog_ng::params::package_name:
      ensure => present,
      before => [
        Concat[$tmp_config_file],
        Exec[syslog_ng_reload]
      ]
    }
    syslog_ng::module {$modules:}
  }

  concat { $tmp_config_file:
    ensure => present,
    path   => $tmp_config_file,
    owner  => $user,
    group  => $group,
    warn   => true,
    ensure_newline => true,
    notify =>  Exec['syslog_ng_reload'],
  }

  notice("tmp_config_file: ${tmp_config_file}")

  concat::fragment {'header':
    target => $tmp_config_file,
    content => $config_file_header,
    order => '01'
  }

  file {$config_file:
    ensure => present,
    path   => $config_file,
    require => Concat[$tmp_config_file]
  }

  service { $::syslog_ng::params::service_name:
    ensure  =>  running,
    require =>  File[$config_file]
  }
}
