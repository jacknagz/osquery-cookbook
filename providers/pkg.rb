use_inline_resources

def whyrun_supported?
  true
end

action :install do
  execute 'install osquery via package' do
    command "installer -pkg #{new_resource.pkg_path} -target /"
    user 'root'
    action :run
  end
  new_resource.updated_by_last_action(true)
end

action :remove do
  %w(osqueryi osqueryd osqueryctl).each do |osquery_bin|
    file osquery_bin do
      action :delete
    end
  end
  new_resource.updated_by_last_action(true)
end
