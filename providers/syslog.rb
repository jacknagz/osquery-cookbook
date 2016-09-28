use_inline_resources

def whyrun_supported?
  true
end

action :create do
  package 'rsyslog' do
    action :install
  end

  pipe = '/var/osquery/syslog_pipe'

  if node['osquery']['options']['syslog_pipe_path']
    pipe = node['osquery']['options']['syslog_pipe_path']
    pipe_user = node['osquery']['syslog']['pipe_user']
    pipe_group = node['osquery']['syslog']['pipe_group']

    execute 'create osquery syslog pipe' do
      command "/usr/bin/mkfifo #{pipe}"
      creates pipe
      action :run
    end

    execute 'chown syslog pipe' do
      command "chown #{pipe_user}:#{pipe_group} #{pipe}"
      action :run
    end

    # rsyslog needs read/write access, osquery process needs read access
    execute 'chmod syslog pipe' do
      command "chmod 460 #{pipe}"
      action :run
    end
  end

  template new_resource.syslog_file do
    owner 'root'
    group 'root'
    mode  '644'
    source rsyslog_legacy ? 'rsyslog/osquery-legacy.conf.erb' : 'rsyslog/osquery.conf.erb'
    variables(pipe: pipe)
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
  cookbook_file new_resource.syslog_file do
    action :delete
    notifies :restart, 'service[rsyslog]', :immediately
  end

  service 'rsyslog' do
    action :nothing
  end
end
