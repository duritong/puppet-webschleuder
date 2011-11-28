# force_password: wether we'd like to enforce a given password, 
#   which users can't change. Only possible for encrypted passwords
#   - default: false
define webschleuder::list(
  $ensure = present,
  $password,
  $password_encrypted = true,
  $force_password = false
){
  include webschleuder

  if ($password_encrypted == false) and $force_password {
    fail("it's not possible to enforcen an unencrypted password for ${name} on ${fqdn}")
  }

  if $ensure == present {
    if $force_password {
      $force_str = "-override"
    } else {
      $force_str = ""
    }
    if $password_encrypted {
      $pwd_str = "-encrypted"
    } else {
      $pwd_str = ""
    }

    case $password {
      'trocla': { $real_password = trocla("webschleuder_${name}",'bcrypt') }
      default: { $real_password = $password }
    }

    exec{"manage_webschleuder_${name}":
      command => "ruby /opt/webschleuder/contrib/enable_webschleuder.rb ${name} '${real_password}' ${pwd_str} ${force_str}",
      require => Exec["manage_schleuder_list_${name}"],
    }
    file{"/var/schleuderlists/${name}/web.conf":
      ensure => file,
      replace => false,
      require => Exec["manage_webschleuder_${name}"],
      owner => schleuder, group => 0, mode => 0600;
    }
    
    if $force_password {
      if $password_encrypted {
        Exec["manage_webschleuder_${name}"]{
          unless => "grep -qE '${real_password}' /var/schleuderlists/${name}/web.conf",
        }
      }
    } else {
      Exec["manage_webschleuder_${name}"]{
        creates => "/var/schleuderlists/${name}/web.conf",
      }
    }
  } else {
    file{"/var/schleuderlists/${name}/web.conf":
      ensure => absent,
    }
  } 
}
