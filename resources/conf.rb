actions :create, :delete
default_action :create

attribute :osquery_conf, kind_of: String, name_attribute: true
attribute :schedule, kind_of: Hash, default: {}, required: true
attribute :packs, kind_of: Array, default: []
attribute :fim_paths, kind_of: Hash, default: {}
attribute :fim_exclude_paths, kind_of: Hash, default: {}
attribute :pack_source, kind_of: String
attribute :decorators, kind_of: Hash, default: {}
