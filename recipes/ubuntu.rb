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
