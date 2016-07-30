#
# Cookbook Name:: osquery
# Recipe:: centos
#
# Copyright 2016, Jack Naglieri
#

centos_version = node['platform_version'].split('.')[0].to_i
repo_url = "#{osquery_s3}/centos#{centos_version}/noarch"
centos_repo = "osquery-s3-centos#{centos_version}-repo-1-0.0.noarch.rpm"

remote_file "#{file_cache}/#{centos_repo}" do
  source "#{repo_url}/#{centos_repo}"
  checksum repo_hashes[:centos][centos_version]
  notifies :install, 'rpm_package[osquery repo]', :immediately
  not_if { node['osquery']['repo']['internal'] }
  action :create
end

rpm_package 'osquery repo' do
  source "#{file_cache}/#{centos_repo}"
  action :nothing
end

package 'osquery' do
  action  :install
  version "#{node['osquery']['version']}-1.el#{centos_version}"
  notifies :create, "osquery_syslog[#{node['osquery']['syslog']['filename']}]"
end

osquery_syslog node['osquery']['syslog']['filename'] do
  action :nothing
  only_if { node['osquery']['syslog']['enabled'] }
end

osquery_conf osquery_config_path do
  schedule    node['osquery']['schedule']
  packs       node['osquery']['packs']
  fim_paths   node['osquery']['file_paths']
  pack_source node['osquery']['pack_source']
  decorators  node['osquery']['decorators']
end

service osquery_daemon do
  action [:enable, :start]
end
