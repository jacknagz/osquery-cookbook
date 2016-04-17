#
# Cookbook Name:: osquery
# Recipe:: mac_os_x
#
# Copyright 2016, Jack Naglieri
#

unless File.exist?('/usr/local/bin/brew')
  Chef::Log.info('** Brew is required, installing now **')
  include_recipe 'homebrew::default'
end

schedule_config = {
  info: {
    query: 'SELECT * FROM osquery_info',
    interval: '86400'
  }
}

domain = 'com.facebook.osqueryd'
config_path = '/var/osquery/osquery.conf'
pid_path = '/var/osquery/osquery.pid'

directory '/var/osquery/packs' do
  recursive true
  mode 0755
end

directory '/var/log/osquery' do
  mode 0755
end

package 'osquery' do
  action :install
  version node['osquery']['version']
  notifies :run, 'execute[osqueryd permissions]', :immediately
end

execute 'osqueryd permissions' do
  command 'chown root:wheel /usr/local/bin/osqueryd'
  action :nothing
end

osquery_conf config_path do
  action :create
  schedule schedule_config
  notifies :restart, "service[#{domain}]"
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

service domain do
  action [:enable, :start]
end
