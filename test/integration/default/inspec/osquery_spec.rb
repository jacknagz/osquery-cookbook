# frozen_string_literal: true

case os[:family]
when 'debian', 'redhat', 'amazon'
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

  describe json('/etc/osquery/osquery.conf') do
    expected_options = {
      'syslog_pipe_path' => '/var/osquery/syslog_pipe',
      'config_plugin' => 'filesystem',
      'logger_plugin' => 'filesystem',
      'schedule_splay_percent' => 10,
      'events_expiry' => 3600,
      'verbose' => false,
      'worker_threads' => 2,
      'logger_path' => '/var/log/osquery'
    }

    expected_schedule = {
      'info' => { 'query' => 'SELECT * FROM osquery_info;', 'interval' => 86_400 }
    }

    its(['options']) { should eq expected_options }
    its(['schedule']) { should eq expected_schedule }
    its(['decorators']) { should eq nil }
    its(['file_paths']) { should eq nil }
    its(['exclude_paths']) { should eq nil }
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
    its('version') { should eq '4.0.2-1.linux' }
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

  describe json('/var/osquery/osquery.conf') do
    expected_options = {
      'syslog_pipe_path' => '/var/osquery/syslog_pipe',
      'config_plugin' => 'filesystem',
      'logger_plugin' => 'filesystem',
      'schedule_splay_percent' => 10,
      'events_expiry' => 3600,
      'verbose' => false,
      'worker_threads' => 2,
      'logger_path' => '/var/log/osquery'
    }

    expected_schedule = {
      'info' => { 'query' => 'SELECT * FROM osquery_info;', 'interval' => 86_400 }
    }

    its(['options']) { should eq expected_options }
    its(['schedule']) { should eq expected_schedule }
    its(['decorators']) { should eq nil }
    its(['file_paths']) { should eq nil }
    its(['exclude_paths']) { should eq nil }
  end
end
