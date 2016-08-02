use_inline_resources

def whyrun_supported?
  true
end

action :create do
  package 'rsyslog' do
    action :install
  end

  cookbook_file new_resource.syslog_file do
    owner 'root'
    group 'root'
    mode  '644'
    source rsyslog_legacy ? 'rsyslog/osquery-legacy.conf' : 'rsyslog/osquery.conf'
    action :create
    notifies :restart, 'service[rsyslog]'
  end

  service 'rsyslog' do
    provider Chef::Provider::Service::Upstart if node['platform'].eql?('ubuntu')
    supports restart: true
    action :nothing
  end
end

action :delete do
  cookbook_file filename do
    action :delete
  end
end
