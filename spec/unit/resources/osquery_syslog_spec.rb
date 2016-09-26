require 'spec_helper'

describe 'osquery_spec::osquery_syslog' do
  include_context 'converged recipe'

  let(:platform) do
    { platform: 'ubuntu', version: '14.04', step_into: %w(osquery_syslog) }
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
    expect(chef_run).to create_cookbook_file('/etc/rsyslog.d/osquery.conf')
  end

  it 'restarts rsyslog via notifies' do
    resource = chef_run.cookbook_file('/etc/rsyslog.d/osquery.conf')
    expect(resource).to notify('service[rsyslog]').to(:restart)
    expect(chef_run.service('rsyslog')).to do_nothing
  end

  it 'creates syslog pipe' do
    expect(chef_run).to run_execute('create osquery syslog pipe')
      .with(command: '/usr/bin/mkfifo /var/osquery/syslog_pipe_test')
  end

  it 'syslog pipe notifies chown and chmod of pipe' do
    pipe = chef_run.execute('create osquery syslog pipe')
    chown = chef_run.execute('chown syslog pipe')
    chmod = chef_run.execute('chmod syslog pipe')

    expect(pipe).to notify('execute[chown syslog pipe]').to(:run).immediately
    expect(pipe).to notify('execute[chmod syslog pipe]').to(:run).immediately

    expect(chown).to do_nothing
    expect(chmod).to do_nothing
  end
end
