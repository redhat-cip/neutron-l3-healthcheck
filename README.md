neutron-l3-healthcheck
======================



Description
===========

Check L3 agents and reschedule routers if an agent is down.


Installation
============

Run the script on the node you want. This node should have access to RPC & MySQL.

Configuration
=============

Create and edit /etc/neutron/l3_healthcheck.ini:

----
 [DEFAULT]
 verbose = True
 debug = True           
 check_interval = 1
 rabbit_password = password
 rabbit_hosts = localhost
 rpc_backend = neutron.openstack.common.rpc.impl_kombu
 [database]
 connection = mysql://root:password@localhost/ovs_neutron?charset=utf8
----

Test it!
========

 python l3_healthcheck --config-file /etc/neutron/l3_healthcheck.ini

You can now test to shoot a L3 agent, and see that routers are rescheduled to another L3 node.

Licence
=======

Apache 2.0
