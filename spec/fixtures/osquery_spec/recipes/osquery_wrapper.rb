# frozen_string_literal: true

node.override['osquery']['pack_source'] = 'osquery_spec'
node.override['osquery']['packs'] = %w[osquery_spec_test]
node.override['osquery']['version'] = '4.0.2'
node.override['osquery']['syslog']['enabled'] = true
node.override['osquery']['fim_enabled'] = false
node.override['osquery']['audit']['enabled'] = false
node.override['osquery']['repo']['internal'] = false
node.override['osquery']['decorators']['always'] = [
  "SELECT 'chefspec' as testIdentifier"
]

include_recipe 'osquery::default'
