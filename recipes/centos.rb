#
# Cookbook Name:: osquery
# Recipe:: centos
#
# Copyright 2016, Jack Naglieri
#

osquery_install node['osquery']['version'] do
  action   :install_centos
  notifies :create, "osquery_syslog[#{node['osquery']['syslog']['filename']}]"
end

osquery_syslog node['osquery']['syslog']['filename'] do
  action   :nothing
  only_if  { node['osquery']['syslog']['enabled'] }
  notifies :restart, "service[#{osquery_daemon}]"
end

osquery_conf osquery_config_path do
  action      :create
  schedule    node['osquery']['schedule']
  packs       node['osquery']['packs']
  fim_paths   node['osquery']['file_paths']
  pack_source node['osquery']['pack_source']
  decorators  node['osquery']['decorators']
  notifies :restart, "service[#{osquery_daemon}]"
end

service osquery_daemon do
  action [:enable, :start]
end
