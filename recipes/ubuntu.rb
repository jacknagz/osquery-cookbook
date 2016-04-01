#
# Cookbook Name:: osquery
# Recipe:: ubuntu
#
# Copyright 2015, Jack Naglieri
#
# All rights reserved - Do Not Redistribute
#

packs_config = {}
node['osquery']['packs'].each do |pack|
  packs_config[pack] = "/usr/share/osquery/packs/#{pack}.conf"
end

schedule_config = {
  info: {
    query: 'SELECT * FROM osquery_info',
    interval: '86400'
  }
}

config_hash = {
  options: node['osquery']['options'],
  schedule: schedule_config,
  packs: packs_config
}

osquery_config = Chef::JSONCompat.to_json_pretty(config_hash)

apt_repository 'osquery' do
  uri 'https://osquery-packages.s3.amazonaws.com/trusty'
  components ['main']
  distribution 'trusty'
  keyserver 'keyserver.ubuntu.com'
  key '1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B'
  action :add
end

include_recipe 'apt::default'

package 'osquery' do
  version "#{node['osquery']['version']}-1.ubuntu14"
  action :install
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

template '/etc/osquery/osquery.conf' do
  source 'osquery.conf.erb'
  mode '0444'
  owner 'root'
  group 'root'
  variables(
    config: osquery_config
  )
  notifies :restart, 'service[osqueryd]'
end

service 'osqueryd' do
  action [:enable, :start]
end
