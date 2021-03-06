/*

== Class: lighttpd::base

Install lighttpd and create resources.

This class shouldn't be included as is as
it's inherited by OS-dependent classes.

*/
class lighttpd::base {

  include concat::setup

  package {"lighttpd":
    ensure => present,
  }

  service {"lighttpd":
    ensure => running,
    enable => true,
    require => Package["lighttpd"],
  }
  exec {"reload-lighttpd":
    command     => "/etc/init.d/lighttpd force-reload",
    refreshonly => true,
    onlyif      => "lighttpd-angel -t -f /etc/lighttpd/lighttpd.conf",
  }

  file { ["/etc/lighttpd/vhosts", "/etc/lighttpd/vhosts-config"]:
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 0755,
    require => Package["lighttpd"],
  }

  concat {"/etc/lighttpd/conf-available/00-puppet-vhost.conf":
    owner   => root,
    group   => root,
    mode    => 0644,
    require => Package["lighttpd"],
  }

  lighttpd::module{"puppet-vhost":
    ensure => present,
    require => File["/etc/lighttpd/conf-available/00-puppet-vhost.conf"],
  }

}
