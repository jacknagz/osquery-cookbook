osquery-pkg
====================
* Installs, configures, and runs [osquery](https://osquery.io/). 
* Installation happens with the package resource, which should use brew.  Versions are pinned based on the attributes listed below.
* The proper configuration and logging folders are created, permissions are adjusted on the osqueryd binary, sample packs/config are dropped into the `/var/osquery/` folder, and LaunchDaemon/syslog files are created.
* Launchctl loads the daemon, and logs start generating in `/var/log/osquery/osqueryd.results.log`

Requirements
------------
* [Homebrew](http://brew.sh/)

Attributes
----------
* `default['osquery']['version'] = '1.6.1'`

Usage
-----
Just include `osquery-pkg` in your node's `run_list`:

Contributing
------------
1. Fork the repository on Github.
2. Create a named feature branch (like `add_component_x`).
3. Write your change.
4. Write tests for your change.
5. Run the tests, ensuring they all pass (rubocop, rspec).
6. Submit a Pull Request using Github.

License and Authors
-------------------
Authors: Jack Naglieri <jnaglierijr@gmail.com>
