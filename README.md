osquery chef cookbook
====================
[![Build Status](https://travis-ci.org/jacknagz/osquery-cookbook.svg?branch=master)](https://travis-ci.org/jacknagz/osquery-cookbook)

* Installs, configures, and starts [osquery](https://osquery.io/).
* Configurations are generated based on node attributes.

Supported Platforms
------------
* OS X
  * Requires [Xcode Command Line Tools](https://itunes.apple.com/us/app/xcode/id497799835?mt=12)
* Ubuntu
* Centos
* Redhat

General Attributes
----------
`attributes/default.rb`:

| name   | type | default | description |
|--------|------|---------|-------------|
| `['osquery']['version']` | `String` | `1.7.0` | osquery version to install |
| `['osquery']['packs']` | `Array` | `%w(incident-response osx-attacks)` | osquery packs found in `files/default/packs/` |
| `['osquery']['repo']['checksum6']` | `String` | - | SHA256 Hash of the centos6 repo |
| `['osquery']['repo']['checksum7']` | `String` | - | SHA256 Hash of the centos7 repo |

Configuration Attributes
----------
`attributes/config.rb`:

| name   | type | default | description |
|--------|------|---------|-------------|
| `['osquery']['options']['config_plugin']` | `String` | `filesystem` | configuration plugin |
| `['osquery']['options']['logger_plugin']` | `String` | `filesystem` | logger plugin |
| `['osquery']['options']['logger_path']` | `String` | `/var/log/osquery` | path to store osquery logs |
| `['osquery']['options']['schedule_splay_percent']` | `Fixnum` | `10` | query schedule splay percentage |
| `['osquery']['options']['events_expiry']` | `Fixnum` | `3600` | timeout to expire eventing pubsub results |
| `['osquery']['options']['verbose']` | `Boolean` | `false` | enable verbose informational messages |
| `['osquery']['options']['worker_threads']` | `Fixnum` | `2` | number of work dispatch threads |
| `['osquery']['options']['enable_monitor']` | `Boolean` | `false` | enable schedule monitor |

Query Schedule Attributes
----------
`attributes/schedule.rb`:

| name   | type | default | description |
|--------|------|---------|-------------|
| `['osquery']['schedule']` | `Hash` | - | osquery schedule |

File Integrity Monitoring Attributes
----------
`attributes/file_paths.rb`:

| name   | type | default | description |
|--------|------|---------|-------------|
| `['osquery']['file_paths']` | `Hash` | - | file paths to monitor events from |

Custom Resources
----------------
`osquery_conf`: create osquery config from selected options and packs.

`create`:

```ruby
osquery_conf '/etc/osquery/osquery.conf' do
  action :create
  schedule node['osquery']['schedule']
  packs node['osquery']['packs']
end
```

`remove`:

```ruby
osquery_conf 'delete osquery config' do
  action :delete
end
```

Testing
-----
`$ rake` to run:
* `foodcritic`
* `rubocop`
* `chefspec`.

`$ kitchen list` to show integration test suites <br />
`$ kitchen converge` to run test suites

Usage
-----
Include `osquery` in your node's `run_list`, and override attributes to fit your desired setup.

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
Authors: Jack Naglieri <jacknagzdev@gmail.com>
License: 'Apache 2.0'
