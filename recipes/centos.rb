#
# Cookbook Name:: osquery
# Recipe:: centos
#
# Copyright 2016, Jack Naglieri
#

# Example schedule config.
schedule_config = {
  info: {
    query: 'SELECT * FROM osquery_info',
    interval: '86400'
  }
}

centos_version = node['platform_version'].split('.')[0].to_i
repo_checksum = node['osquery']['repo']["checksum#{centos_version}"]
repo_url = "https://osquery-packages.s3.amazonaws.com/centos#{centos_version}/noarch"
centos6_repo = "osquery-s3-centos#{centos_version}-repo-1-0.0.noarch.rpm"
file_cache = Chef::Config['file_cache_path']

remote_file "#{file_cache}/#{centos6_repo}" do
  source "#{repo_url}/#{centos6_repo}"
  checksum repo_checksum
  notifies :install, 'rpm_package[osquery repo]', :immediately
  action :create
end

rpm_package 'osquery repo' do
  source "#{file_cache}/#{centos6_repo}"
  action :nothing
end

package 'osquery' do
  action :install
end

osquery_conf '/etc/osquery/osquery.conf' do
  action :create
  schedule schedule_config
  notifies :restart, 'service[osqueryd]'
end

node['osquery']['packs'].each do |pack|
  cookbook_file "/usr/share/osquery/packs/#{pack}.conf" do
    mode '0444'
    source "packs/#{pack}.conf"
    owner 'root'
    group 'root'
    notifies :restart, 'service[osqueryd]'
  end
end

service 'osqueryd' do
  action [:enable, :start]
end
