#
# Cookbook Name:: osquery
# Recipe:: ubuntu
#
# Copyright 2016, Jack Naglieri
#

os_version = node['platform_version'].split('.')[0].to_i
os_codename = node['lsb']['codename']

apt_repository 'osquery' do
  uri File.join(osquery_s3, os_codename)
  components ['main']
  arch 'amd64'
  distribution os_codename
  keyserver 'keyserver.ubuntu.com'
  key '1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B'
  action :add
end

include_recipe 'apt::default'

package 'osquery' do
  version "#{node['osquery']['version']}-1.ubuntu#{os_version}"
  action :install
end

osquery_conf '/etc/osquery/osquery.conf' do
  schedule node['osquery']['schedule']
  packs node['osquery']['packs']
  notifies :restart, 'service[osqueryd]'
end

service 'osqueryd' do
  action [:enable, :start]
end
