class nova-common::install {
  $nova_common_packages = [ "nova-common", "nova-doc", "python-nova", "python-eventlet", "python-mysqldb" ]

  if !$package_repo {
    $package_repo = "http://devpackages.ansolabs.com"
  }

  # FIXME(ja): move this to rcb common, then glance, keystone, ... don't need to require nova common
  apt::source { "rcb":
    location => $package_repo,
    release => "maverick",
    repos => "main",
    key => "460DF9BE",
    key_server => "keyserver.ubuntu.com",
    pin => "1"
  }

  apt::source { "nova-ppa":
    location => "http://ppa.launchpad.net/nova-core/trunk/ubuntu",
    release => "maverick",
    repos => "main",
    key => "2A2356C9",
    key_server => "keyserver.ubuntu.com"
  }

  package { $nova_common_packages:
    ensure  => latest,
    require => [Apt::Source["rcb"], Apt::Source["nova-ppa"]]
  }
  
  file { "nova-default":
    path => "/etc/default/nova-common",
    content => "ENABLED=1",
    require => Package["nova-common"]
  }

}
