# == Class: neutron_l3_healthcheck
#
# Installs & configure neutron-l3-healthcheck
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*enabled*]
#   (required) Whether or not to enable the quantum service
#   true/false
#
# [*package_ensure*]
#   (optional) The state of the package
#   Defaults to 'present'
#
# [*verbose*]
#   (optional) Verbose logging
#   Defaults to False
#
# [*debug*]
#   (optional) Print debug messages in the logs
#   Defaults to False
#
# [*check_interval*]
#   (optional) seconds between periodic check
#   Defaults to 10
#
# [*rpc_backend*]
#   (optional) what rpc/queuing service to use
#   Defaults to impl_kombu (rabbitmq)
#
# [*rabbit_password*]
# [*rabbit_port*]
# [*rabbit_user*]
#   (optional) Various rabbitmq settings
#
# [*rabbit_hosts*]
#   (optional) array of rabbitmq servers for HA
#   Defaults to localhost
#
# [*plugin_host*]
#   (required) Host to ping for checking network connectivity
#
# [*post_script*]
#   (optional) Script executed after rescheduling
#   Default to empty
#
# [*isolated_period*]
#   (optional) Seconds before an isolated agent removes routers
#   Default to 30.
#
# [*lock_validity*]
#   (optional) Seconds of the lock validity
#   Default to 5.
#
# [*validity_period*]
#   (optional) Reset admin_state_up after validity period
#   Default to 60.
#
# === Examples
#
#  class { neutron_l3_healthcheck:
#    rabbit_password = 'some_password'
#  }
#
# === Authors
#
# François Charlier <francois.charlier@enovance.com>
# Emilien Macchi <emilien.macchi@enovance.com>
#
# === Copyright
#
# Copyright © 2013 eNovance <licensing@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class neutron_l3_healthcheck (
  $enabled             = true,
  $package_ensure      = present,
  $verbose             = false,
  $debug               = false,
  $check_interval      = 10,
  $plugin_host         = undef,
  $post_script         = undef,
  $isolated_period     = '30',
  $lock_validity       = '5',
  $validity_period     = '60',
  $rabbit_password     = false,
  $rabbit_hosts        = ['localhost'],
  $rabbit_user         = 'guest',
  $rabbit_virtual_host = '/',
  $rpc_backend         = 'impl_kombu',
  $db_connection       = 'mysql://localhost/ovs_neutron?charset=utf8'
) {

  if ! $rabbit_password {
    fail('When rpc_backend is rabbitmq, you must set rabbit password')
  }

  if ! $plugin_host {
    fail('plugin_host is missing.')
  }

  if $post_script {
    neutron_l3_healthcheck_config {
      'HEALTHCHECK/post_script': value => $post_script;
    }
  }

  neutron_l3_healthcheck_config {
    'DEFAULT/verbose':               value => $verbose;
    'DEFAULT/debug':                 value => $debug;
    'DEFAULT/rabbit_password':       value => $rabbit_password;
    'DEFAULT/rabbit_hosts':          value => $rabbit_hosts;
    'DEFAULT/rabbit_user':           value => $rabbit_user;
    'DEFAULT/rabbit_virtual_host':   value => $rabbit_virtual_host;
    'DEFAULT/rpc_backend':           value => "neutron.openstack.common.rpc.${rpc_backend}";
    'database/connection':           value => $db_connection;
    'L3HEALTHCHECK/check_interval':  value => $check_interval;
    'L3HEALTHCHECK/plugin_host':     value => $plugin_host;
    'L3HEALTHCHECK/isolated_period': value => $isolated_period;
    'L3HEALTHCHECK/lock_validity':   value => $lock_validity;
    'L3HEALTHCHECK/validity_period': value => $validity_period;
  }

  package { 'neutron-l3-healthcheck':
    ensure => present
  }

  service { 'neutron-l3-healthcheck':
    ensure  => running,
    enable  => true,
    require => Package['neutron-l3-healthcheck']
  }



}
