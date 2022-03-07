# @summary Manage syslog-ng
#
# @author Copyright 2014 Tibor Benke
#
# The main class of this module. By including it you get an installed syslog-ng with default configuration on your system.
#
# @param config_file
#   Configures the path of the configuration file.
# @param package_name
#   Name of the package to manage when `manage_package` is `true`.
# @param service_name
#   Name of the syslog-ng service.
# @param module_prefix
#   A string to prepend to syslog-ng module names to obtain the corresponding package names.
# @param config_file_header
#   A header string that appear on top of the syslog-ng configuration.
# @param package_ensure
#   The value of the `ensure` parameter of package resources.
# @param manage_repo
#   Controls if the module is managing the unofficial repositories of syslog-ng packages. Use true if you want to use the latest version of syslog-ng from the unofficial Debian repository or unofficial RedHat repository.
# @param manage_package
#   Controls if the module is managing the package resource or not. Use false if you are already handling this in your manifests.
# @param manage_init_defaults
#   Controls if the module is managing the init script's config file (See init_config_file and init_config_hash).
# @param modules
#   Configures additional syslog-ng modules. If `manage_package` is set to `true` this will also install the corresponding packages, *e.g.* `syslog-ng-riemann` on RedHat if `modules = ['riemann']`.
# @param sbin_path
#   Configures the path, where `syslog-ng` and `syslog-ng-ctl` binaries can be found.
# @param user
#   Configures `syslog-ng` to run as `user`.
# @param group
#   Configures `syslog-ng` to run as `group`.
# @param syntax_check_before_reloads
#   The module always checks the syntax of the generated configuration. If it is not OK, the main configuration (usually /etc/syslog-ng/syslog-ng.conf) will not be overwritten, but you can disable this behavior by setting this parameter to false.
# @param init_config_file
#   Path to the init script configuration file.
# @param init_config_hash
#   Hash of init configuration options to put into `init_config_file`. This has OS specific defaults which will be merged to user specified value.
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
