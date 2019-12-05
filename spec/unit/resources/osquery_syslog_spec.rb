# frozen_string_literal: true

require 'spec_helper'

describe 'osquery_spec::osquery_syslog' do
  include_context 'converged recipe'

  let(:platform) do
    { platform: 'ubuntu', version: '14.04', step_into: %w[osquery_syslog] }
  end

  before do
    allow_any_instance_of(Chef::Resource).to receive(:rsyslog_legacy).and_return(Chef::Version.new('7.4.4'))
  end

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'creates osquery_syslog' do
    expect(chef_run).to create_osquery_syslog('/etc/rsyslog.d/osquery.conf')
  end

  it 'installs rsyslog' do
    expect(chef_run).to install_package('rsyslog')
  end

  it 'creates the osquery syslog conf' do
    expect(chef_run).to create_template('/etc/rsyslog.d/osquery.conf')
      .with_variables(
        pipe_filter: 'daemon,cron.*',
        pipe: '/var/osquery/syslog_pipe_test'
      )
  end

  it 'restarts rsyslog via notifies' do
    resource = chef_run.template('/etc/rsyslog.d/osquery.conf')
    expect(resource).to notify('service[rsyslog]').to(:restart)
    expect(chef_run.service('rsyslog')).to do_nothing
  end

  it 'creates syslog pipe' do
    expect(chef_run).to run_execute('create osquery syslog pipe')
      .with(command: '/usr/bin/mkfifo /var/osquery/syslog_pipe_test')
  end

  it 'modifies permissions and ownership of syslog pipe' do
    expect(chef_run).to run_execute('chown syslog pipe')
    expect(chef_run).to run_execute('chmod syslog pipe')
  end
end
