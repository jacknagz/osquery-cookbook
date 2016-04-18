property :osquery_conf, kind_of: String, name_property: true
property :schedule, kind_of: Hash, default: {}, required: true
property :packs, kind_of: Array, default: []
property :file_paths, kind_of: Hash, default: {}

default_action :create

action :create do
  if packs.empty?

    config_hash = {
      options: node['osquery']['options'],
      schedule: schedule
    }

  else

    packs_config = {}
    case node['platform']
    when 'mac_os_x'
      packs_dir = '/var/osquery/packs'
    when 'centos', 'ubuntu'
      packs_dir = '/usr/share/osquery/packs'
    end

    directory '/var/osquery/packs' do
      recursive true
      mode 0755
      only_if { node['platform'].eql?('mac_os_x') }
    end

    packs.each do |pack|
      cookbook_file "#{packs_dir}/#{pack}.conf" do
        mode '0444'
        source "packs/#{pack}.conf"
        owner 'root'
        group 'root'
      end
    end

    packs.each do |pack|
      packs_config[pack] = "#{packs_dir}/#{pack}.conf"
    end

    config_hash = {
      options: node['osquery']['options'],
      schedule: schedule,
      packs: packs_config
    }

  end

  template osquery_conf do
    source 'osquery.conf.erb'
    mode '0444'
    owner 'root'
    group 'root'
    variables(
      config: Chef::JSONCompat.to_json_pretty(config_hash)
    )
  end
end

action :delete do
  file '/etc/osquery/osquery.conf' do
    action :delete
  end

  directory packs_dir do
    action :delete
    recursive true
  end
end
