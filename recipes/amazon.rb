# frozen_string_literal: true

#
# Cookbook Name:: osquery
# Recipe:: amazon
#
#

osquery_install node['osquery']['version'] do
  action  :install_amazon
  upgrade node['osquery']['repo']['package_upgrade']
end

osquery_syslog node['osquery']['syslog']['filename'] do
  action      :create
  pipe_filter node['osquery']['syslog']['pipe_filter']
  pipe_path   node['osquery']['options']['syslog_pipe_path']
  only_if     { node['osquery']['syslog']['enabled'] }
  notifies    :restart, "service[#{osquery_daemon}]"
end

osquery_conf osquery_config_path do
  action      :create
  schedule    node['osquery']['schedule']
  packs       node['osquery']['packs']
  fim_paths   node['osquery']['file_paths']
  fim_exclude_paths node['osquery']['exclude_paths']
  pack_source node['osquery']['pack_source']
  decorators  node['osquery']['decorators']
  notifies :restart, "service[#{osquery_daemon}]"
end

service osquery_daemon do
  action %i[enable start]
end
