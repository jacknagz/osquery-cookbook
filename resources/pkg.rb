property :pkg_path, kind_of: String, name_property: true
resource_name :osquery_pkg

default_action :install

action :install do
  execute 'install osquery via package' do
    command "installer -pkg #{pkg_path} -target /"
    user 'root'
    action :run
  end
end

action :remove do
  %w(osqueryi osqueryd osqueryctl).each do |osquery_bin|
    file osquery_bin do
      action :delete
    end
  end
end
