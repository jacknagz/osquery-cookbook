# osquery version and packs.
default['osquery']['version'] = '1.8.1'
default['osquery']['pack_source'] = 'osquery'
default['osquery']['packs'] = %w(osquery-monitoring)

# misc options.
default['osquery']['syslog']['enabled'] = true
default['osquery']['syslog']['filename'] = '/etc/rsyslog.d/60-osquery.conf'
default['osquery']['repo']['internal'] = false
default['osquery']['audit']['enabled'] = true
