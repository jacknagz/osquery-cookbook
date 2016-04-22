#
# Cookbook Name:: osquery
# Recipe:: centos
#
# Copyright 2016, Jack Naglieri
#

centos_version = node['platform_version'].split('.')[0].to_i
repo_checksum = node['osquery']['repo']["checksum#{centos_version}"]
repo_url = "#{osquery_s3}/centos#{centos_version}/noarch"
centos_repo = "osquery-s3-centos#{centos_version}-repo-1-0.0.noarch.rpm"
file_cache = Chef::Config['file_cache_path']

remote_file "#{file_cache}/#{centos_repo}" do
  source "#{repo_url}/#{centos_repo}"
  checksum repo_checksum
  notifies :install, 'rpm_package[osquery repo]', :immediately
  action :create
end

rpm_package 'osquery repo' do
  source "#{file_cache}/#{centos_repo}"
  action :nothing
end

package 'osquery' do
  version "#{node['osquery']['version']}-1.el#{centos_version}"
  action :install
end

osquery_conf osquery_config_path do
  schedule node['osquery']['schedule']
  packs node['osquery']['packs']
  fim_paths node['osquery']['file_paths']
  notifies :restart, 'service[osqueryd]'
end

service 'osqueryd' do
  action [:enable, :start]
end
