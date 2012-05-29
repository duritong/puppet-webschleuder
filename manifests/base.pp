class webschleuder::base {
  require schleuder

  include rubygems::activerecord
  include rubygems::bcrypt
  include rubygems::camping
  include rubygems::markaby
  include rubygems::rack

  include rubygems::sqlite

  if $webschleuder_install_dir == '' {
    $webschleuder_install_dir  = '/opt/webschleuder'
  }

  git::clone{'webschleuder':
    git_repo => 'git://git.immerda.ch/webschleuder.git',
    projectroot => $webschleuder_install_dir,
    cloneddir_group => 'schleuder',
    cloneddir_restrict_mode => false,
    require => [ Package['camping'], Package['markaby'], Package['activerecord'] ]
  }

  file{'/etc/schleuder/webschleuder.conf':
    source => [ "puppet:///modules/site_webschleuder/config/${fqdn}/webschleuder.conf",
                "puppet:///modules/site_webschleuder/config/webschleuder.conf",
                "puppet:///modules/webschleuder/config/webschleuder.conf" ],
    owner => root, group => schleuder, mode => 0640;
  }
}
