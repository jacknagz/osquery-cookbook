# frozen_string_literal: true

PACKAGE_SUFFIX = '-1.linux'

def whyrun_supported?
  true
end

# Add Apt repo and install osquery package.
action :install_ubuntu do
  package_version = "#{new_resource.version}#{PACKAGE_SUFFIX}"
  package_action = new_resource.upgrade ? :upgrade : :install

  apt_repository 'osquery' do
    action        :add
    uri           ::File.join(osquery_s3, 'deb')
    components    ['main']
    arch          'amd64'
    distribution  'deb'
    keyserver     'keyserver.ubuntu.com'
    key           repo_hashes[:ubuntu][:key]
    not_if { node['osquery']['repo']['internal'] }
    not_if { ::File.exist?('/etc/apt/sources.list.d/osquery.list') }
  end

  package 'osquery' do
    action   package_action
    version  package_version
  end
end

# Setup CentOS repo and install osquery package.
action :install_centos do
  package_version = "#{new_resource.version}#{PACKAGE_SUFFIX}"
  package_action = new_resource.upgrade ? :upgrade : :install

  yum_repository 'osquery' do
    baseurl 'https://s3.amazonaws.com/osquery-packages/rpm/$basearch/'
    gpgkey 'https://pkg.osquery.io/rpm/GPG'
    action :create
  end

  package 'osquery' do
    action   package_action
    version  package_version
  end
end

action :install_amazon do
  package_version = "#{new_resource.version}#{PACKAGE_SUFFIX}"
  package_action = new_resource.upgrade ? :upgrade : :install

  yum_repository 'osquery' do
    baseurl 'https://s3.amazonaws.com/osquery-packages/rpm/$basearch/'
    gpgkey 'https://pkg.osquery.io/rpm/GPG'
    action :create
  end

  package 'osquery' do
    action   package_action
    version  package_version
  end
end

# Download os x pkg, setup directories, permissions, plist files, and install.
action :install_os_x do
  domain = 'com.facebook.osqueryd'
  package_name = "osquery-#{new_resource.version}.pkg"
  package_url = "#{osquery_s3}/darwin/#{package_name}"
  package_file = "#{file_cache}/#{package_name}"

  remote_file package_file do
    action   :create
    source   package_url
    checksum mac_os_x_pkg_hashes[node['osquery']['version']]
    notifies :run, 'execute[install osquery]', :immediately
    only_if  { osx_upgradable }
  end

  directory '/var/log/osquery' do
    mode '0755'
  end

  execute 'install osquery' do
    action :nothing
    user 'root'
    command "installer -pkg #{package_file} -target /"
    notifies :run, 'execute[osqueryd permissions]', :immediately
  end

  execute 'osqueryd permissions' do
    command 'chown root:wheel /usr/local/bin/osqueryd'
    action :nothing
  end

  template "/Library/LaunchDaemons/#{domain}.plist" do
    source 'launchd.plist.erb'
    mode '0644'
    owner 'root'
    group 'wheel'
    variables(
      domain: domain,
      config_path: osquery_config_path,
      pid_path: '/var/osquery/osquery.pid'
    )
    notifies :restart, "service[#{domain}]"
  end
end

# remove apt repo and osquery package.
action :remove_ubuntu do
  service osquery_daemon do
    action %i[disable stop]
    only_if { ::File.exist?('/etc/init.d/osqueryd') && ::File.exist?(osquery_config_path) }
  end

  apt_repository 'osquery' do
    action :remove
    not_if { node['osquery']['repo']['internal'] }
  end

  package 'osquery' do
    action :purge
  end

  directory '/var/osquery' do
    action :delete
    recursive true
  end
end

# remove osquery package.
action :remove_centos do
  service osquery_daemon do
    action %i[disable stop]
  end

  package 'osquery' do
    action :purge
  end
end

# delete osquery binary files.
action :remove_os_x do
  %w[osqueryi osqueryd osqueryctl].each do |osquery_bin|
    file osquery_bin do
      action :delete
    end
  end
end
