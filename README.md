osquery chef cookbook
====================
[![Build Status](https://travis-ci.org/jacknagz/osquery-cookbook.svg?branch=master)](https://travis-ci.org/jacknagz/osquery-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/osquery.svg)](https://supermarket.chef.io/cookbooks/osquery)

* Installs, configures, and starts [osquery](https://osquery.io/).
* Configurations are generated based on node attributes.

Requirements
------------
* Chef >= 12.1.0
* OS X
* Ubuntu
  * 12.04
  * 14.04
* Centos/Redhat
  * 6.5+
  * 7.0+

General Attributes
----------
`attributes/default.rb`:

| name   | type | default | description |
|--------|------|---------|-------------|
| `['osquery']['version']` | `String` | `1.7.4` | osquery version to install |
| `['osquery']['packs']` | `Array` | `%w(incident-response osx-attacks)` | osquery packs found in `files/default/packs/` |
| `['osquery']['pack_source']` | `String` | `osquery` | cookbook to load osquery packs from |
| `['osquery']['repo']['el6_checksum']` | `String` | - | SHA256 Hash of the centos6 repo |
| `['osquery']['repo']['el7_checksum']` | `String` | - | SHA256 Hash of the centos7 repo |
| `['osquery']['repo']['osx_checksum']` | `String` | - | SHA256 Hash of the os x pkg file |
| `['osquery']['audit']['enabled']` | `Boolean` | `true` | flag to enable/disable chef audits |

Configuration Attributes
----------
`attributes/config.rb`:

| name   | type | default | description |
|--------|------|---------|-------------|
| `['osquery']['options']['config_plugin']` | `String` | `filesystem` | configuration plugin |
| `['osquery']['options']['logger_plugin']` | `String` | `filesystem` | logger plugin |
| `['osquery']['options']['schedule_splay_percent']` | `Fixnum` | `10` | query schedule splay percentage |
| `['osquery']['options']['events_expiry']` | `Fixnum` | `3600` | timeout to expire eventing pubsub results |
| `['osquery']['options']['verbose']` | `Boolean` | `false` | enable verbose informational messages |
| `['osquery']['options']['worker_threads']` | `Fixnum` | `2` | number of work dispatch threads |
| `['osquery']['options']['enable_monitor']` | `Boolean` | `false` | enable schedule monitor |
| `['osquery']['syslog']['enabled']` | `Boolean` | `true` | enable syslog tables |
| `['osquery']['syslog']['filename']` | `String` | `/etc/rsyslog.d/60-osquery.conf` | syslog conf file path |

Query Schedule Attributes
----------
`attributes/schedule.rb`:

| name   | type | default | description |
|--------|------|---------|-------------|
| `['osquery']['schedule']` | `Hash` | osquery_info and file_events | osquery schedule |

File Integrity Monitoring Attributes
----------
`attributes/file_paths.rb`:

| name   | type | default | description |
|--------|------|---------|-------------|
| `['osquery']['file_paths']` | `Hash` | homes, etc, and tmp | file paths to monitor events from |
| `['osquery']['fim_enabled']` | `Boolean` | false | enable/disable file event tracking in config |

Custom Resources
----------------
`osquery_conf`: creates osquery config from selected options and packs.

`create`:

```ruby
osquery_conf osquery_config_path do
  action :create
  schedule node['osquery']['schedule']
  fim_paths node['osquery']['file_paths']
  packs node['osquery']['packs']
  pack_source node['osquery']['pack_source']
end
```

`delete`:

```ruby
osquery_conf 'delete osquery config' do
  action :delete
end
```

osquery_conf attributes:
* action: `:create` or `:delete`
* schedule: (required) Hash of scheduled queries to run
* fim_paths: (optional) Hash of file integrity monitoring path descriptions and array of their paths
* packs: (optional) List of osquery packs to install.  Based on filenames ending in `*.conf` in `pack_source/packs`
* pack_source: (optional) Cookbook source for osquery packs
* The daemon configuration is compiled from the node`['osquery']['options']` attributes.

Testing
-----
Run `$ rake` to execute:
* foodcritic
* rubocop
* chefspec

Requirements: VirtualBox with Extension Pack (for the OS X vm)
* `$ kitchen list` to show integration test suites <br />
* `$ kitchen converge` to run test suites

Note: Audit mode is enabled in the Kitchen yaml by default.  The tests are found in `./recipes/audit.rb` and run post converge.  To disable, override the `node['osquery']['audit']['enabled']` attribute to `false`.

Usage
-----
* Include `osquery` in your node's `run_list`
* Override attributes to fit your desired setup

Contributing
------------
1. Fork the repository on Github.
2. Create a named feature branch (like `add_component_x`).
3. Write your change.
4. Write tests for your change.
5. Run the tests, ensuring they all pass (`rubocop; rspec`).
6. Submit a Pull Request using Github.

License and Authors
-------------------
* Authors: Jack Naglieri (jacknagzdev@gmail.com)

```text
Copyright 2013-2014 Jack Naglieri <jacknagzdev@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
