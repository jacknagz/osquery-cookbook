#
# Cookbook Name:: osquery-pkg
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Domain used by the OS X LaunchDaemon.
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

packs = ['ir', 'osx-attacks']
packs.each do |pack|
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
  variables(domain: domain,
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

cookbook_file '/var/osquery/osquery.conf' do
  source 'osquery.conf'
  mode '0444'
  owner 'root'
  group 'wheel'
  notifies :restart, "service[#{domain}]"
end

service domain do
  action [:enable, :start]
end
