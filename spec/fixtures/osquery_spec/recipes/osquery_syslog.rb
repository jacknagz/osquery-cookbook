node.override['osquery']['syslog']['enabled'] = true

osquery_syslog node['osquery']['syslog']['filename'] do
  action :create
  only_if { node['osquery']['syslog']['enabled'] }
end
