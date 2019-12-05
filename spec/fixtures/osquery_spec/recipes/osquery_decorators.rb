# frozen_string_literal: true

#
# Cookbook Name:: osquery_spec
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

node.default['osquery']['decorators']['always'] = [
  "SELECT 'web server' as roleIdentifier",
  "SELECT 'production' as envIdentifier"
]
node.override['osquery']['pack_source'] = 'osquery_spec'
node.override['osquery']['packs'] = %w[osquery_spec_test]

include_recipe 'osquery::default'
