# == Type: keystone_endpoint
#
# Includes the keystone endpoint class
# for the specified service
#
define openstack_extras::keystone_endpoint() {

  include "::${name}::keystone::auth"

}
