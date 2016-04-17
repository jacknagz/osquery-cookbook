property :osquery_conf, kind_of: String, name_property: true
property :schedule, kind_of: Hash, default: {}

default_action :create

action :create do
  packs_config = {}
  case node['platform']
  when 'mac_os_x'
    packs_dir = '/var/osquery/packs'
  when 'centos' || 'ubuntu'
    packs_dir = '/usr/share/osquery/packs'
  end

  node['osquery']['packs'].each do |pack|
    packs_config[pack] = "#{packs_dir}/#{pack}.conf"
  end

  config_hash = {
    options: node['osquery']['options'],
    schedule: schedule,
    packs: packs_config
  }

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
end
