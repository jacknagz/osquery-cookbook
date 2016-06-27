use_inline_resources

def whyrun_supported?
  true
end

action :create do
  package 'rsyslog' do
    action :install
    not_if { app_installed('rsyslog') }
  end

  cookbook_file new_resource.syslog_file do
    owner 'root'
    group 'root'
    mode  '644'
    source rsyslog_legacy ? 'rsyslog/osquery-legacy.conf' : 'rsyslog/osquery.conf'
    action :create
    notifies :restart, 'service[rsyslog]', :immediately
  end

  service 'rsyslog' do
    action :nothing
    supports restart: true
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  cookbook_file filename do
    action :delete
  end
  new_resource.updated_by_last_action(true)
end
