osquery Cookbook
====================
[![Build Status](https://travis-ci.org/jacknagz/osquery-cookbook.svg?branch=master)](https://travis-ci.org/jacknagz/osquery-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/osquery.svg)](https://supermarket.chef.io/cookbooks/osquery)

This cookbook includes recipes and resources to install, configure, and start Facebook's  [osquery](https://osquery.io/).  osquery is an operating system instrumentation framework for OS X/macOS, Windows, and Linux.

Supported
------------
#### Platforms
  * Ubuntu: 12.04, 14.04, 16.04
  * Centos/Redhat: 6.5, 7.0
  * OS X

#### Chef
  * Chef 11+

#### Cookbooks
  * [`apt`](https://github.com/chef-cookbooks/apt)

#### Usage
  * Include `osquery::default` in your node's run_list
  * Override attributes to fit your desired setup

Recipes
-------
#### default
The `default` recipe determines if a node is within the supported platform list and includes the one of the platform specific recipes to setup osquery.

#### centos/ubuntu/mac_os_x
  * Install osquery via package (rpm, deb, or pkg)
  * Setup syslog ingestion if enabled
  * Create configuration file(s)
  * Start/enable osqueryd service

Attributes
----------
##### attributes/default.rb:
Default attributes control the version to install, syslog configuration, and whether or not to use Facebook's Apt/Yum repo or your own internal repo.

| name   | type | default | description |
|--------|------|---------|-------------|
| `['osquery']['version']` | `String` | `2.2.1` | osquery version to install |
| `['osquery']['packs']` | `Array` | `%w(incident-response osx-attacks)` | packs to install |
| `['osquery']['pack_source']` | `String` | `osquery` | cookbook to load osquery packs from |
| `['osquery']['repo']['internal']` | `Boolean` | `false` | enable/disable the use the facebook repo |
| `['osquery']['syslog']['enabled']` | `Boolean` | `true` | enable syslog tables |
| `['osquery']['syslog']['filename']` | `String` | `/etc/rsyslog.d/60-osquery.conf` | syslog conf file path |
| `['osquery']['syslog']['pipe_user']` | `String` | `root` | syslog pipe user |
| `['osquery']['syslog']['pipe_group']` | `String` | `root` | syslog pipe group |

##### attributes/config.rb:
Config attributes add options to the osquery config `options` key.  This includes logger plugins, config plugin, splay, worker threads, and more.

| name   | type | default | description |
|--------|------|---------|-------------|
| `['osquery']['options']['config_plugin']` | `String` | `filesystem` | configuration plugin |
| `['osquery']['options']['logger_plugin']` | `String` | `filesystem` | logger plugin |
| `['osquery']['options']['schedule_splay_percent']` | `Fixnum` | `10` | query schedule splay percentage |
| `['osquery']['options']['events_expiry']` | `Fixnum` | `3600` | timeout to expire eventing pubsub results |
| `['osquery']['options']['verbose']` | `Boolean` | `false` | enable verbose informational messages |
| `['osquery']['options']['worker_threads']` | `Fixnum` | `2` | number of work dispatch threads |
| `['osquery']['options']['enable_monitor']` | `Boolean` | `false` | enable schedule monitor |
| `['osquery']['options']['syslog_pipe_path']` | `String` | `/var/osquery/syslog_pipe_test` | syslog pipe path |

##### attributes/schedule.rb:
Schedule attributes control the main osquery query schedule.  You can add additional queries this way:

```
default['osquery']['schedule']['query_name'] = {
  query: 'SELECT * FROM table_name;',
  interval: '86400',
  description: 'my new query'
}
```

| name   | type | default | description |
|--------|------|---------|-------------|
| `['osquery']['schedule']` | `Hash` | osquery_info | osquery scheduled queries |

##### attributes/file_paths.rb:
File integrity monitoring paths.

| name   | type | default | description |
|--------|------|---------|-------------|
| `['osquery']['fim_enabled']` | `Boolean` | false | enable/disable file event tracking in config |
| `['osquery']['file_paths']` | `Hash` | homes, etc, and tmp | file paths to monitor events from |
| `['osquery']['exclude_paths']` | `Hash` | homes, etc, and tmp | file paths to ignore monitor events from (category must exist in file_paths) |

##### attributes/decorators.rb:
Decorator query options.

| name   | type | default | description |
|--------|------|---------|-------------|
| `['osquery']['decorators']` | `Hash` | `{}` | load, always, or interval decorator queries |

## Custom Resources
##### `osquery_conf`: creates osquery config from selected options and packs

* actions: `:create` or `:delete`
* schedule: (required) Hash of scheduled queries to run
* fim_paths: (optional) Hash of file integrity monitoring path descriptions and array of their paths
* packs: (optional) List of osquery packs to install.  Based on filenames ending in `*.conf` in `pack_source/packs`
* pack_source: (optional) Cookbook source for osquery packs
* The daemon configuration is compiled from the node`['osquery']['options']` attributes.

`create`:

```ruby
osquery_conf osquery_config_path do
  action      :create
  schedule    node['osquery']['schedule']
  fim_paths   node['osquery']['file_paths']
  fim_exclude_paths   node['osquery']['exclude_paths']
  packs       node['osquery']['packs']
  pack_source node['osquery']['pack_source']
  decorators  node['osquery']['decorators']
end
```

`delete`:

```ruby
osquery_conf 'delete osquery config' do
  action :delete
end
```

##### `osquery_install`: installs osquery on centos/redhat, ubuntu, or os x

* actions:
  * `:install_ubuntu`, `:install_centos`, `:install_os_x`
  * `:remove_ubuntu`, `:remove_centos`, `:remove_os_x`
* version: (required - name attribute) string of the osquery version to install

`install`:

```ruby
osquery_install node['osquery']['version'] do
  action :install_ubuntu
end
```

`remove`:

```ruby
osquery_install node['osquery']['version'] do
  action :remove_ubuntu
end
```

##### `osquery_syslog`: creates osquery syslog config file

* actions: `:create` or `:delete`
* syslog_file: (required - name attribute) filename of the osquery syslog config
* pipe_filter: the filter expression for routing events into the syslog pipe
* pipe_path: the fifo pipe path
* note: this resource installs rsyslog if not already configured

`install`:

```ruby
osquery_syslog node['osquery']['syslog']['filename'] do
  pipe_filter node['osquery']['syslog']['pipe_filter']
  pipe_path   node['osquery']['options']['syslog_pipe_path']
  action      :create
  only_if     { node['osquery']['syslog']['enabled'] }
  notifies    :restart, "service[#{osquery_daemon}]"
end
```

`delete`:

```ruby
osquery_syslog node['osquery']['syslog']['filename'] do
  action   :delete
  notifies :restart, "service[#{osquery_daemon}]"
end
```

Testing
-----
Run `rake` to execute:
* foodcritic
* rubocop
* chefspec

Run `kitchen verify` to run Inspec integration tests
* Requirements: VirtualBox with Extension Pack (for the OS X vm)

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
