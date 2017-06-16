# osquery version and packs.
default['osquery']['version'] = '2.4.0'
default['osquery']['pack_source'] = 'osquery'
default['osquery']['packs'] = %w(osquery-monitoring)

# syslog options.
default['osquery']['syslog']['enabled'] = true
default['osquery']['syslog']['filename'] = '/etc/rsyslog.d/60-osquery.conf'
default['osquery']['options']['syslog_pipe_path'] = '/var/osquery/syslog_pipe'
default['osquery']['syslog']['pipe_user'] = 'root'
default['osquery']['syslog']['pipe_group'] = 'root'
default['osquery']['syslog']['pipe_filter'] = '*.*'

# other options.
default['osquery']['repo']['package_upgrade'] = false
default['osquery']['repo']['internal'] = false
