osquery
====================
* Installs, configures, and runs [osquery](https://osquery.io/). 
* Installation occurs with the package resource, which uses brew.  Versions are pinned based on the attribute below.
* The proper configuration and logging folders are created, permissions are adjusted on the osqueryd binary, sample packs/configuration are dropped into the `/var/osquery/` folder, and `LaunchDaemon`/`syslog` files are created.
* Configurations are generated based on node attributes.
* Launchctl loads the daemon, and logs start generating in `/var/log/osquery/osqueryd.results.log`

Requirements
------------
* [Homebrew](http://brew.sh/)
* [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12)

Attributes
----------
Version, supported platforms, and pinned osquery package version:
* `default['osquery']['version'] = '1.6.1'`
* `default['osquery']['supported']  = ['mac_os_x']`
* `default['osquery']['version']    = '1.6.1'`

Controls which packs are installed and added to the configuration:
* `default['osquery']['packs'] = ['incident-response', 'osx-attacks']`

Parameters for osquery:
* `default['osquery']['options']['config_plugin']  = 'filesystem'`
* `default['osquery']['options']['logger_plugin']  = 'filesystem'`
* `default['osquery']['options']['logger_path']    = '/var/log/osquery'`
* `default['osquery']['options']['schedule_splay_percent'] = '10'`
* `default['osquery']['options']['events_expiry']  = '3600'`
* `default['osquery']['options']['verbose']        = 'false'`
* `default['osquery']['options']['worker_threads'] = '2'`
* `default['osquery']['options']['enable_monitor'] = 'true'`

Usage
-----
Just include `osquery` in your node's `run_list`!

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
