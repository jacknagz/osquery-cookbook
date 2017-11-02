use_inline_resources

def whyrun_supported?
  true
end

def fim_enabled?
  node['osquery']['fim_enabled']
end

def fim_file_paths_used?
  fim_enabled? && !new_resource.fim_paths.empty?
end

def fim_exclude_file_paths_used?
  fim_file_paths_used? && !new_resource.fim_exclude_paths.empty?
end

action :create do
  config_hash = { options: node['osquery']['options'], schedule: new_resource.schedule }
  config_hash[:file_paths] = new_resource.fim_paths if fim_file_paths_used?
  config_hash[:exclude_paths] = new_resource.fim_exclude_paths if fim_exclude_file_paths_used?
  config_hash[:decorators] = new_resource.decorators unless new_resource.decorators.empty?

  unless new_resource.packs.empty?
    directory osquery_packs_path do
      action :create
      recursive true
      mode '0755'
    end

    new_resource.packs.each do |pack|
      cookbook_file "#{osquery_packs_path}/#{pack}.conf" do
        mode '0664'
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

  directory ::File.dirname(osquery_config_path) do
    owner 'root'
    group osquery_file_group
    mode '0755'
  end

  template new_resource.osquery_conf do
    source 'osquery.conf.erb'
    mode '0440'
    owner 'root'
    sensitive true
    group osquery_file_group
    cookbook 'osquery'
    variables(
      config: Chef::JSONCompat.to_json_pretty(config_hash)
    )
  end
end

action :delete do
  file new_resource.osquery_conf do
    action :delete
  end

  directory ::File.dirname(osquery_config_path) do
    action :delete
    recursive true
  end

  directory osquery_packs_path do
    action :delete
    recursive true
  end
end
