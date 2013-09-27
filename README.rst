:Author: Sylvain Afchain
:Source Code: https://github.com/enovance/neutron-l3-healthcheck
:License: Apache
:Version: 1.2

======================
neutron-l3-healthcheck
======================

Check L3 agents and reschedule routers if an agent is down.


*******
Install
*******
1. Install the script on the node you want. You can run this script on multiple
   nodes at the same time.
::

2. Configure /etc/neutron/l3_healthcheck.ini file:
::

  [DEFAULT]
  verbose = True
  debug = True
  rabbit_password = password
  rabbit_hosts = localhost
  rpc_backend = neutron.openstack.common.rpc.impl_kombu

  [database]
  sql_connection = mysql://root:password@localhost/ovs_neutron?charset=utf8

  [L3HEALTHCHECK]
  check_interval = 3
  plugin_host =

  # Script executed after rescheduling
  # post_script =

  # Seconds before an isolated agent removes routers
  # isolated_period = 30

  # Seconds of the lock validity
  # lock_validity = 5

  # Reset admin_state_up after validity period
  # validity_period = 60


*****
Usage
*****

Run the script:
    -$ python l3_healthcheck --config-file /etc/neutron/l3_healthcheck.ini


You can now test to shoot a L3 agent, and see that routers are rescheduled to another L3 node.
