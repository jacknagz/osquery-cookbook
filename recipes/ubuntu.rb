#
# Cookbook Name:: osquery
# Recipe:: ubuntu
#
# Copyright 2016, Jack Naglieri
#

ubuntu_version = node['platform_version'].split('.')[0].to_i
case ubuntu_version
when 14
  ubuntu_release = 'trusty'
when 12
  ubuntu_release = 'precise'
end

apt_repository 'osquery' do
  uri "https://osquery-packages.s3.amazonaws.com/#{ubuntu_release}"
  components ['main']
  distribution ubuntu_release
  keyserver 'keyserver.ubuntu.com'
  key '1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B'
  action :add
end

include_recipe 'apt::default'

package 'osquery' do
  version "#{node['osquery']['version']}-1.ubuntu#{ubuntu_version}"
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
