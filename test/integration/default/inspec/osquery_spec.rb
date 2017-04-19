case os[:family]
when 'debian', 'redhat'
  describe service('osqueryd') do
    it { should be_installed }
    it { should be_running }
    it { should be_enabled }
  end

  describe file('/etc/osquery/osquery.conf') do
    it { should exist }
    it { should be_file }
    its('mode') { should cmp '0440' }
  end

  describe file('/usr/share/osquery/packs') do
    it { should exist }
    it { should be_directory }
    its('mode') { should cmp '0755' }
  end

  describe file('/etc/osquery') do
    it { should exist }
    it { should be_directory }
    its('mode') { should cmp '0755' }
  end

  describe package('osquery') do
    it { should be_installed }
    its('version') { should eq '2.4.0-1.linux' }
  end

when 'darwin'
  describe file('/var/osquery/osquery.conf') do
    it { should exist }
    it { should be_file }
    its('mode') { should cmp '0440' }
  end

  describe launchd_service('com.facebook.osqueryd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
