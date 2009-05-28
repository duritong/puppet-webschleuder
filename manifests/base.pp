class webschleuder::base {
  include schleuder

  include rubygems::activerecord
  include rubygems::bcrypt
  include rubygems::camping
  include rubygems::markaby
  include rubygems::rack

  if $webschleuder_install_dir == '' {
    $webschleuder_install_dir  = '/opt/webschleuder'
  }

  git::clone{'webschleuder':
    git_repo => 'git://git.immerda.ch/webschleuder.git',
    projectroot => $webschleuder_install_dir,
    cloneddir_group => 'schleuder',
    require => [ User::Managed['schleuder'], Package['camping'], Package['markaby'], Package['activerecord'] ]
  }

  file{'/etc/schleuder/webschleuder.conf':
    source => [ "puppet://$server/files/webschleuder/config/${fqdn}/webschleuder.conf",
                "puppet://$server/files/webschleuder/config/webschleuder.conf",
                "puppet://$server/webschleuder/config/webschleuder.conf" ],
    owner => root, group => schleuder, mode => 0640;
  }
}
