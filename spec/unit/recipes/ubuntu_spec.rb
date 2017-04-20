require 'spec_helper'

describe 'osquery::ubuntu' do
  include_context 'converged recipe'

  let(:node_attributes) do
    {
      'osquery' => {
        'version' => '2.3.0',
        'packs' => %w[chefspec]
      }
    }
  end

  let(:platform) do
    { platform: 'ubuntu', version: '14.04', step_into: ['osquery_install'] }
  end

  before do
    stub_command('which rsyslogd').and_return('/usr/sbin/rsyslogd')
    stub_command('`which rsyslogd` -v ').and_return('rsyslogd 7.4.4 \n')
  end

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'installs osquery' do
    expect(chef_run).to install_osquery_ubuntu('2.3.0')
  end

  it 'installs osquery package' do
    expect(chef_run).to install_package('osquery')
    # .with(version: '1.7.3-1.ubuntu14')
  end

  it 'sets up syslog for osquery' do
    expect(chef_run).to create_osquery_syslog('/etc/rsyslog.d/60-osquery.conf')
  end

  it 'adds osquery apt repo' do
    expect(chef_run).to add_apt_repository('osquery')
  end

  it 'creates osquery config' do
    expect(chef_run).to create_osquery_config('/etc/osquery/osquery.conf')
      .with(
        pack_source: 'osquery',
        packs: %w[chefspec],
        decorators: {}
      )
  end

  it 'starts and enables osquery service' do
    expect(chef_run).to enable_service('osqueryd')
    expect(chef_run).to start_service('osqueryd')
  end
end
