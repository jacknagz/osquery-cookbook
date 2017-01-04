#
# Cookbook Name:: osquery
# Recipe:: default
#
# Copyright 2016, Jack Naglieri
#

unless supported_platform
  Chef::Log.warn("** Unsupported version #{node['platform']}:#{node['platform_version']} **")
  return
end

if node['osquery']['options']['logger_plugin'].include?('filesystem')
  node.default['osquery']['options']['logger_path'] = '/var/log/osquery'
end

case node['platform']
when 'redhat'
  include_recipe 'osquery::centos'
else
  include_recipe "osquery::#{node['platform']}"
end
