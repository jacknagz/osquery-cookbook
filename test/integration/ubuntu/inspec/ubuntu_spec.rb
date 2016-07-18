describe service('osqueryd') do
  it { should be_installed }
  it { should be_running }
  it { should be_enabled }
end

describe file('/etc/osquery/osquery.conf') do
  it { should exist }
  it { should be_file }
end

describe file('/var/osquery/syslog_pipe') do
  it { should exist }
  it { should be_pipe }
end

describe package('osquery') do
  it { should be_installed }
end
