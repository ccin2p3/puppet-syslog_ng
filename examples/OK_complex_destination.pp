class { 'syslog_ng':
  config_file                 => '/tmp/syslog-ng.conf',
  manage_package              => false,
  syntax_check_before_reloads => false,
  user                        => 'balabit',
  group                       => 'balabit',
  manage_init_defaults        => false,
}

$coloss_analyzer = 'coloss-analyzer.example.com'
$coloss_analyzers = ['coloss-analyzer-failover.example.com', 'coloss-analyzer.example.com']
::syslog_ng::destination { 'd_coloss':
  params => [
    { 'syslog-ng' => flatten([
          { 'server'     => "'${coloss_analyzer}'" },
          { 'failover'   => [
              { 'servers'  => $coloss_analyzers.map |$server| { "\"${server}\"" } },
              { 'failback' => ['successful-probes-required(3)', 'tcp-probe-interval(5)'] },
            ],
          },
          { 'port'       => 514 },
      ])
    }
  ],
}
