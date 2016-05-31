property :syslog_file, kind_of: String, name_property: true
resource_name :osquery_syslog

default_action :create

action :create do
  package 'rsyslog' do
    action :install
    not_if { app_installed('rsyslog') }
  end

  cookbook_file syslog_file do
    owner 'root'
    group 'root'
    mode  '644'
    source rsyslog_legacy ? 'rsyslog/osquery-legacy.conf' : 'rsyslog/osquery.conf'
    action :create
    notifies :restart, 'service[rsyslog]', :immediately
  end

  service 'rsyslog' do
    action :nothing
  end
end

action :delete do
  cookbook_file filename do
    action :delete
  end
end
