use_inline_resources

def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::OsquerySyslog.new(new_resource.syslog_file)
  @current_resource.pipe_filter(new_resource.pipe_filter)
  @current_resource.pipe_path(new_resource.pipe_path)
end

action :create do
  package 'rsyslog' do
    action :install
  end

  default_pipe = '/var/osquery/syslog_pipe'.freeze
  pipe_filter = new_resource.pipe_filter
  pipe_path = new_resource.pipe_path

  # we only need to create the pipe manually if it's not the default config
  unless pipe_path.eql?(default_pipe)
    pipe_user = node['osquery']['syslog']['pipe_user']
    pipe_group = node['osquery']['syslog']['pipe_group']

    unless ::File.exist?(current_resource.pipe_path)
      execute 'create osquery syslog pipe' do
        command "/usr/bin/mkfifo #{pipe_path}"
        creates pipe_path
        action :run
      end

      execute 'chown syslog pipe' do
        command "chown #{pipe_user}:#{pipe_group} #{pipe_path}"
        action :run
      end

      # rsyslog needs read/write access, osquery process needs read access
      execute 'chmod syslog pipe' do
        command "chmod 460 #{pipe_path}"
        action :run
      end
      new_resource.updated_by_last_action(true)
    end
  end

  template new_resource.syslog_file do
    owner 'root'
    group 'root'
    mode  '644'
    source rsyslog_legacy ? 'rsyslog/osquery-legacy.conf.erb' : 'rsyslog/osquery.conf.erb'
    variables(
      pipe: pipe_path,
      pipe_filter: pipe_filter
    )
    action :create
    notifies :restart, 'service[rsyslog]'
  end

  service 'rsyslog' do
    if node['platform'].eql?('ubuntu')
      if os_version < 16
        provider Chef::Provider::Service::Upstart
      else
        provider Chef::Provider::Service::Systemd
      end
    end
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
