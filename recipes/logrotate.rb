logrotate_app 'osquery' do
  cookbook 'logrotate'
  path "#{node['osquery']['options']['logger_path']}/osqueryd.results.log"
  frequency 'daily'
  create '644 root logs'
  rotate 7
end
