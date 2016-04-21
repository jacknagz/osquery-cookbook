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

if node['platform'].eql?('redhat')
  include_recipe 'osquery::centos'
else
  include_recipe "osquery::#{node['platform']}"
end

# TODO(jacknagz): if chef version 12.1
include_recipe 'osquery::audit'
