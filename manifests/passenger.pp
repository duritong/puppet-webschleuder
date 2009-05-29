class webschleuder::passenger {
  include webschleuder
  include passenger::apache

  file{ [ '/var/schleuderlists/webschleuder_data', '/var/schleuderlists/webschleuder_data/tmp' ]:
    ensure => directory,
    require => User::Managed['schleuder'],
    owner => schleuder, group => 0, mode => 0600;
  }
  file{'/var/schleuderlists/webschleuder_data/camping.db':
    ensure => present,
    require => User::Managed['schleuder'],
    owner => schleuder, group => 0, mode => 0600;
  }
  file{'/opt/webschleuder/config.ru':
    require => Git::Clone['webschleuder'],
    owner => schleuder, group => 0, mode => 0644;
  }
}
