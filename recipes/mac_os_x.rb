#
# Cookbook Name:: osquery
# Recipe:: mac_os_x
#
# Copyright 2015, Jack Naglieri
#
# All rights reserved - Do Not Redistribute
#

unless File.exist?('/usr/local/bin/brew')
  Chef::Log.info('** Brew is required, installing now **')
  include_recipe 'homebrew::default'
end

packs_config = {}
node['osquery']['packs'].each do |pack|
  packs_config[pack] = "/var/osquery/packs/#{pack}.conf"
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

domain = 'com.facebook.osqueryd'
config_path = '/var/osquery/osquery.conf'
pid_path = '/var/osquery/osquery.pid'

package 'osquery' do
  action :install
  version node['osquery']['version']
  notifies :run, 'execute[osqueryd permissions]', :immediately
end

execute 'osqueryd permissions' do
  command 'chown root:wheel /usr/local/bin/osqueryd'
  action :nothing
end

directory '/var/osquery/packs' do
  recursive true
  mode 0755
end

directory '/var/log/osquery' do
  mode 0755
end

node['osquery']['packs'].each do |pack|
  cookbook_file "/var/osquery/packs/#{pack}.conf" do
    mode '0444'
    source "packs/#{pack}.conf"
    owner 'root'
    group 'wheel'
    notifies :restart, "service[#{domain}]"
  end
end

template "/Library/LaunchDaemons/#{domain}.plist" do
  source 'launchd.plist.erb'
  mode '0644'
  owner 'root'
  group 'wheel'
  variables(
    domain: domain,
    config_path: config_path,
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

template '/var/osquery/osquery.conf' do
  source 'osquery.conf.erb'
  mode '0444'
  owner 'root'
  group 'wheel'
  variables(
    config: osquery_config
  )
  notifies :restart, "service[#{domain}]"
end

service domain do
  action [:enable, :start]
end
