# @summary Manage the syslog-ng repository
#
# @api private
class syslog_ng::repo {
  assert_private()

  if $syslog_ng::manage_repo {
    $major_release = $facts['os']['release']['major']

    case $facts['os']['family'] {
      'Redhat', 'Amazon': {
        yumrepo { 'czanik-syslog-ng-githead':
          ensure   => present,
          name     => 'czanik-syslog-ng-githead',
          descr    => 'Copr repo for syslog-ng-githead owned by czanik',
          baseurl  => "https://copr-be.cloud.fedoraproject.org/results/czanik/syslog-ng-githead/epel-${major_release}-\$basearch/",
          gpgkey   => 'https://copr-be.cloud.fedoraproject.org/results/czanik/syslog-ng-githead/pubkey.gpg',
          enabled  => '1',
          gpgcheck => '1',
          before   => Package[$syslog_ng::package_name],
        }
      }
      'Debian': {
        $release_url = 'https://ose-repo.syslog-ng.com/apt/'

        apt::source { 'syslog-ng-obs':
          comment  => 'syslog-ng ose repository',
          location => $release_url,
          repos    => "${fact('os.name')}-${fact('os.distro.codename')}".downcase,
          release  => 'stable',
          key      => {
            name    => 'syslog-ng.asc',
            # https://ose-repo.syslog-ng.com/apt/syslog-ng-ose-pub.asc
            content => file("${module_name}/syslog-ng-ose-pub.asc"),
          },
          include  => {
            deb => true,
            src => false,
          },
        }

        Class['apt::update'] -> Package[$syslog_ng::package_name]
      }
      default: {}
    }
  }
}
