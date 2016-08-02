require 'spec_helper'

describe 'osquery::centos' do
  include_context 'converged recipe'

  let(:node_attributes) do
    {
      'osquery' => {
        'packs' => %w(chefspec),
        'version' => '1.7.3'
      }
    }
  end

  let(:platform) do
    { platform: 'centos', version: '7.0', step_into: ['osquery_install'] }
  end

  let(:repo) { 'osquery-s3-centos7-repo-1-0.0.noarch.rpm' }

  before do
    stub_command('which rsyslogd').and_return('/usr/sbin/rsyslogd')
    stub_command('`which rsyslogd` -v ').and_return('rsyslogd 7.4.4 \n')
  end

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'installs osquery' do
    expect(chef_run).to install_osquery_centos('1.7.3')
  end

  it 'sets up syslog for osquery' do
    resource = chef_run.osquery_install('1.7.3')
    expect(resource).to notify('osquery_syslog[/etc/rsyslog.d/60-osquery.conf]').to(:create)
  end

  it 'installs osquery package' do
    expect(chef_run).to install_package('osquery')
  end

  it 'install osquery repo' do
    expect(chef_run).to_not install_rpm_package('osquery repo')
  end

  it 'get osquery repo' do
    expect(chef_run).to create_remote_file("#{Chef::Config['file_cache_path']}/#{repo}")
  end

  it 'creates osquery config' do
    expect(chef_run).to create_osquery_config('/etc/osquery/osquery.conf')
      .with(
        pack_source: 'osquery',
        packs: %w(chefspec),
        decorators: {}
      )
  end

  it 'starts and enables osquery service' do
    expect(chef_run).to enable_service('osqueryd')
    expect(chef_run).to start_service('osqueryd')
  end
end
