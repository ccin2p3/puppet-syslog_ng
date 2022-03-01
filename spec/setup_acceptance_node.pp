# Needed for facter to fetch facts used by the apt module
if $facts['os']['name'] == 'Ubuntu' {
  package{ 'lsb-release':
    ensure => present,
  }
}

user { 'balabit':
  ensure => present,
}
