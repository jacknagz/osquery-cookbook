# frozen_string_literal: true

#
# Cookbook Name:: osquery_spec
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

node.override['osquery']['schedule'] = {
  version: {
    query: 'SELECT version FROM osquery_info;',
    interval: 86_400
  }
}
node.default['osquery']['decorators']['always'] = [
  "SELECT 'web server' as roleIdentifier",
  "SELECT 'production' as envIdentifier"
]
node.override['osquery']['pack_source'] = 'osquery_spec'
node.override['osquery']['packs'] = %w[osquery_spec_test]

osquery_conf osquery_config_path do
  action      :create
  schedule    node['osquery']['schedule']
  packs       node['osquery']['packs']
  pack_source node['osquery']['pack_source']
  decorators  node['osquery']['decorators']
  notifies    :restart, "service[#{osquery_daemon}]"
end

service osquery_daemon do
  action :nothing
end
