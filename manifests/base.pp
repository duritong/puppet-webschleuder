class webschleuder::base {
  include schleuder

  if $webschleuder_install_dir == '' {
    $webschleuder_install_dir  = '/opt/webschleuder'
  }

  git::clone{'webschleuder':
    git_repo => 'git://git.immerda.ch/webschleuder.git',
    projectroot => $webschleuder_install_dir,
    cloneddir_group => 'schleuder',
    require => User::Managed['schleuder'],
  }
}
