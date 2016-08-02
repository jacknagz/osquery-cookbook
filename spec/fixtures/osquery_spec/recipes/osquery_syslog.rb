node.override['osquery']['syslog']['enabled'] = true
node.override['osquery']['syslog']['filename'] = '/etc/rsyslog.d/osquery.conf'

osquery_syslog node['osquery']['syslog']['filename'] do
  action :create
  only_if { node['osquery']['syslog']['enabled'] }
  notifies :restart, "service[#{osquery_daemon}]"
end

service osquery_daemon do
  action :nothing
end
