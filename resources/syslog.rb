actions :create, :delete
default_action :create

attribute :syslog_file, kind_of: String, name_attribute: true
attribute :pipe_filter, kind_of: String, default: '*.*'
attribute :pipe_path, kind_of: String, default: '/var/osquery/syslog_pipe'
