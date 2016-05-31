# config/logger configuration.
default['osquery']['options']['config_plugin']  = 'filesystem'
default['osquery']['options']['logger_plugin']  = 'filesystem'

# daemon configuration.
default['osquery']['options']['schedule_splay_percent'] = 10
default['osquery']['options']['events_expiry']  = 3600
default['osquery']['options']['verbose']        = false
default['osquery']['options']['worker_threads'] = 2
default['osquery']['options']['enable_monitor'] = false

# extra options
default['osquery']['syslog']['enabled'] = true
default['osquery']['syslog']['filename'] = '/etc/rsyslog.d/60-osquery.conf'
