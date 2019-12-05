# frozen_string_literal: true

osquery_install node['osquery']['version'] do
  action :remove_ubuntu
end

osquery_syslog node['osquery']['syslog']['filename'] do
  action   :delete
  only_if  { node['osquery']['syslog']['enabled'] }
end

osquery_conf osquery_config_path do
  action :delete
end
