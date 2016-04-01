#
# Cookbook Name:: osquery
# Recipe:: default
#
# Copyright 2015, Jack Naglieri
#
# All rights reserved - Do Not Redistribute
#

unless node['osquery']['supported'].include?(node['platform'])
  Chef::Log.warn("** Warning: Unsupported version #{node['platform']} **")
  return
end

include_recipe "osquery::#{node['platform']}"
