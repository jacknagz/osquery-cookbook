#
# Cookbook Name:: osquery
# Recipe:: default
#
# Copyright 2016, Jack Naglieri
#

unless node['osquery']['supported'].include?(node['platform'])
  Chef::Log.warn("** Unsupported version #{node['platform']} **")
  return
end

include_recipe "osquery::#{node['platform']}"
