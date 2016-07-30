#
# Cookbook Name:: osquery
# Recipe:: mac_os_x
#
# Copyright 2016, Jack Naglieri
#

file_cache = Chef::Config['file_cache_path']
osx_checksum = node['osquery']['repo']['osx_checksum']

package_name = "osquery-#{node['osquery']['version']}.pkg"
package_url = "#{osquery_s3}/darwin/#{package_name}"
package_file = "#{file_cache}/#{package_name}"

remote_file package_file do
  source package_url
  checksum osx_checksum[node['osquery']['version']]
  notifies :install, "osquery_pkg[#{package_file}]", :immediately
  only_if { osx_upgradable }
  action :create
end

osquery_pkg package_file do
  action :nothing
  notifies :run, 'execute[osqueryd permissions]', :immediately
end

domain = 'com.facebook.osqueryd'
pid_path = '/var/osquery/osquery.pid'

directory '/var/log/osquery' do
  mode '0755'
end

execute 'osqueryd permissions' do
  command 'chown root:wheel /usr/local/bin/osqueryd'
  action :nothing
end

osquery_conf osquery_config_path do
  schedule    node['osquery']['schedule']
  packs       node['osquery']['packs']
  fim_paths   node['osquery']['file_paths']
  pack_source node['osquery']['pack_source']
  decorators  node['osquery']['decorators']
  notifies    :restart, "service[#{domain}]"
end

template "/Library/LaunchDaemons/#{domain}.plist" do
  source 'launchd.plist.erb'
  mode '0644'
  owner 'root'
  group 'wheel'
  variables(
    domain: domain,
    config_path: osquery_config_path,
    pid_path: pid_path
  )
  notifies :restart, "service[#{domain}]"
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
