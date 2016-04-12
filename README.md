osquery
====================
[![Build Status](https://travis-ci.org/jacknagz/osquery-cookbook.svg?branch=master)](https://travis-ci.org/jacknagz/osquery-cookbook)

* Installs, configures, and starts [osquery](https://osquery.io/). 
* Cross-platform support: `OS X`, `Ubuntu`, and `Centos` (soon).
* Configurations are generated based on node attributes.

Requirements
------------
* OS X
  * [Homebrew](http://brew.sh/)
  * [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12)

* Ubuntu
  * None

Attributes
----------
osquery version and supported platforms
* `default['osquery']['version'] = '1.7.0'`
* `default['osquery']['supported']  = ['mac_os_x', 'ubuntu']`

controls which packs are installed and added to the configuration:
* `default['osquery']['packs'] = ['incident-response', 'osx-attacks']`

parameters for osquery conf:
* `default['osquery']['options']['config_plugin']  = 'filesystem'`
* `default['osquery']['options']['logger_plugin']  = 'filesystem'`
* `default['osquery']['options']['logger_path']    = '/var/log/osquery'`
* `default['osquery']['options']['schedule_splay_percent'] = '10'`
* `default['osquery']['options']['events_expiry']  = '3600'`
* `default['osquery']['options']['verbose']        = 'false'`
* `default['osquery']['options']['worker_threads'] = '2'`
* `default['osquery']['options']['enable_monitor'] = 'true'`

Custom Resources
----------------

* osquery_conf: create osquery config from selected options and packs.

`create`:

```ruby
osquery_conf '/etc/osquery/osquery.conf' do
  action :create
  schedule schedule_config
  notifies :restart, 'service[osqueryd]'
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
`$ rake`: executes `foodcritic`, `rubocop`, and `chefspec`.

Usage
-----
Include `osquery` in your node's `run_list`!

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
Authors: Jack Naglieri <jnaglierijr@gmail.com>
