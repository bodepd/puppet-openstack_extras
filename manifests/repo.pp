class openstack_extras::repo {

  case $::osfamily {
    'Debian': {
      include openstack_extras::repo::uca
    }
    'RedHat': {
      include openstack_extras::repo::rdo
    }
    default: {
      fail("Unsupported os family :${::osfamly}")
    }
  }
}
