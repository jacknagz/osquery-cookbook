#
# Cookbook Name:: osquery
# Recipe:: default
#
# Copyright 2016, Jack Naglieri
#

supported_platforms = %w(
  mac_os_x
  ubuntu
  centos
  redhat
)

unless supported_platforms.include?(node['platform'])
  Chef::Log.warn("** Unsupported version #{node['platform']} **")
  return
end

case node['osquery']['options']['logger_plugin']
when 'filesystem'
  node.default['osquery']['options']['logger_path'] = '/var/log/osquery'
end

case node['platform']
when 'redhat'
  include_recipe 'osquery::centos'
else
  include_recipe "osquery::#{node['platform']}"
end

include_recipe 'osquery::audit' if compat_audit && node['osquery']['audit']['enabled']
