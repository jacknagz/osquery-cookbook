#
# Cookbook Name:: osquery
# Recipe:: mac_os_x
#
# Copyright 2016, Jack Naglieri
#

domain = 'com.facebook.osqueryd'

osquery_install node['osquery']['version'] do
  action :install_os_x
end

osquery_conf osquery_config_path do
  schedule    node['osquery']['schedule']
  packs       node['osquery']['packs']
  fim_paths   node['osquery']['file_paths']
  fim_exclude_paths node['osquery']['exclude_paths']
  pack_source node['osquery']['pack_source']
  decorators  node['osquery']['decorators']
  notifies    :restart, "service[#{domain}]"
end

cookbook_file "/etc/newsyslog.d/#{domain}.conf" do
  source "#{domain}.conf"
  mode '0644'
  owner 'root'
  group 'wheel'
end

service osquery_daemon do
  action [:enable, :start]
end
