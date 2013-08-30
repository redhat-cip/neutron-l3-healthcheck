:Author: Sylvain Afchain
:Source Code: https://github.com/enovance/neutron-l3-healthcheck
:License: Apache
:Version: 0.1

======================
neutron-l3-healthcheck
======================

Check L3 agents and reschedule routers if an agent is down.


*******
Install
*******
1. Install the script on the node you want. This one should have access to RPC & MySQL
::

2. Configure /etc/neutron/l3_healthcheck.ini file:
::

  [DEFAULT]
  verbose = True
  debug = True           
  check_interval = 3
  rabbit_password = password
  rabbit_hosts = localhost
  rpc_backend = neutron.openstack.common.rpc.impl_kombu
  [database]
  connection = mysql://root:password@localhost/ovs_neutron?charset=utf8



*****
Usage
*****

Run the script:
    -$ python l3_healthcheck --config-file /etc/neutron/l3_healthcheck.ini 


You can now test to shoot a L3 agent, and see that routers are rescheduled to another L3 node.
