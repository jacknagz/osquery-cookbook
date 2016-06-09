use_inline_resources

def whyrun_supported?
  true
end

action :create do
  config_hash = {
    options: node['osquery']['options'],
    schedule: new_resource.schedule
  }

  unless new_resource.packs.empty?

    directory osquery_packs_path do
      action :create
      recursive true
      mode 0644
    end

    new_resource.packs.each do |pack|
      cookbook_file "#{osquery_packs_path}/#{pack}.conf" do
        mode '0440'
        source "packs/#{pack}.conf"
        owner 'root'
        group osquery_file_group
        cookbook new_resource.pack_source unless new_resource.pack_source.nil?
      end
    end

    packs_config = {}

    new_resource.packs.each do |pack|
      packs_config[pack] = "#{osquery_packs_path}/#{pack}.conf"
    end

    config_hash[:packs] = packs_config
  end

  config_hash[:file_paths] = new_resource.fim_paths if node['osquery']['fim_enabled'] && !new_resource.fim_paths.empty?

  template new_resource.osquery_conf do
    source 'osquery.conf.erb'
    mode '0440'
    owner 'root'
    sensitive true
    group osquery_file_group
    variables(
      config: Chef::JSONCompat.to_json_pretty(config_hash)
    )
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  file new_resource.osquery_conf do
    action :delete
  end

  directory osquery_packs_path do
    action :delete
    recursive true
  end
  new_resource.updated_by_last_action(true)
end
