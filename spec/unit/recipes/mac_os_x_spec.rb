# frozen_string_literal: true

require 'spec_helper'

describe 'osquery::mac_os_x' do
  include_context 'converged recipe'

  let(:node_attributes) do
    {
      'osquery' => {
        'packs' => %w[osx_pack],
        'version' => '1.7.4'
      }
    }
  end

  let(:platform) do
    { platform: 'mac_os_x', version: '10.13', step_into: %w[osquery_conf osquery_install] }
  end

  before do
    allow_any_instance_of(Chef::Resource).to receive(:osquery_current_version).and_return(Chef::Version.new('1.7.2'))
  end

  let(:osquery_vers) { '1.7.4' }
  let(:domain) { 'com.facebook.osqueryd' }
  let(:pkg) { "/var/chef/cache/osquery-#{osquery_vers}.pkg" }
  osquery_dirs = %w[/var/log/osquery /var/osquery/packs /var/osquery]

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'installs osquery' do
    expect(chef_run).to install_osquery_os_x(osquery_vers)
  end

  osquery_dirs.each do |dir|
    it "creates #{dir}" do
      expect(chef_run).to create_directory(dir)
    end
  end

  it 'installs the a pack' do
    expect(chef_run)
      .to create_cookbook_file('/var/osquery/packs/osx_pack.conf')
      .with(group: 'wheel', user: 'root')
  end

  context 'osx_upgradable true' do
    it 'downloads pkg file' do
      expect(chef_run).to create_remote_file(pkg)
    end
  end

  it 'installs pkg file' do
    downloaded_pkg = chef_run.remote_file(pkg)
    expect(downloaded_pkg).to notify('execute[install osquery]')
      .to(:run).immediately
    expect(chef_run.execute('install osquery')).to do_nothing
  end

  it 'creates osquery config' do
    expect(chef_run).to create_osquery_config('/var/osquery/osquery.conf')
  end

  it 'creates osquery conf via lwrp' do
    expect(chef_run)
      .to create_template('/var/osquery/osquery.conf')
      .with(group: 'wheel', user: 'root', mode: '0440')
  end

  it 'creates osquery LaunchDaemon' do
    expect(chef_run)
      .to create_template("/Library/LaunchDaemons/#{domain}.plist")
      .with(group: 'wheel', user: 'root')
  end

  it 'creates osquery syslog conf entry' do
    expect(chef_run)
      .to create_cookbook_file("/etc/newsyslog.d/#{domain}.conf")
      .with(group: 'wheel', user: 'root')
  end

  it 'starts and enables osquery service' do
    expect(chef_run).to enable_service(domain)
    expect(chef_run).to start_service(domain)
  end

  it 'notifies to run permission mod' do
    install = chef_run.execute('install osquery')
    expect(install).to notify('execute[osqueryd permissions]')
      .to(:run).immediately
  end

  it 'modifies osquery binary permissions' do
    expect(chef_run)
      .to_not run_execute('chown root:wheel /usr/local/bin/osqueryd')
  end
end
