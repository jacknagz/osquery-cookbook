# frozen_string_literal: true

require 'spec_helper'

describe 'osquery_spec::osquery_remove' do
  include_context 'converged recipe'

  let(:platform) do
    {
      platform: 'ubuntu',
      version: '14.04',
      step_into: %w[osquery_syslog osquery_install osquery_conf]
    }
  end

  let(:node_attributes) do
    {
      'osquery' => {
        'version' => '1.8.2',
        'syslog' => {
          'enabled' => true,
          'filename' => '/etc/rsyslog.d/chefspec-osquery.conf'
        },
        'repo' => {
          'internal' => true
        }
      }
    }
  end

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'removes osquery package via lwrp' do
    expect(chef_run).to remove_osquery_ubuntu('1.8.2')
  end

  it 'removes osquery syslog file via lwrp' do
    expect(chef_run).to delete_osquery_syslog('/etc/rsyslog.d/chefspec-osquery.conf')
  end

  it 'deletes osquery conf via lwrp' do
    expect(chef_run).to delete_osquery_config('/etc/osquery/osquery.conf')
  end

  it 'deletes osquery syslog conf' do
    osquery_conf = chef_run.cookbook_file('/etc/rsyslog.d/chefspec-osquery.conf')
    expect(chef_run).to delete_cookbook_file('/etc/rsyslog.d/chefspec-osquery.conf')
    expect(osquery_conf).to notify('service[rsyslog]').to(:restart).immediately

    rsyslog = chef_run.service('rsyslog')
    expect(rsyslog).to do_nothing
  end

  it 'purges the osquery package' do
    expect(chef_run).to purge_package('osquery')
  end

  it 'stops and disables the osqueryd service' do
    allow(File).to receive(:exist?).and_return(true)

    expect(chef_run).to stop_service('osqueryd')
    expect(chef_run).to disable_service('osqueryd')
  end

  it 'does not remove an apt repo' do
    expect(chef_run).to_not remove_apt_repository('osquery')
  end

  %w[/etc/osquery /var/osquery /usr/share/osquery/packs].each do |osquery_path|
    it "deletes the #{osquery_path} path" do
      expect(chef_run).to delete_directory(osquery_path)
        .with(recursive: true)
    end
  end

  it 'deletes the osquery conf file' do
    expect(chef_run).to delete_file('/etc/osquery/osquery.conf')
  end
end
