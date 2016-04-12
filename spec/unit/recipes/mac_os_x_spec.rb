require 'spec_helper'

describe 'osquery::mac_os_x' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.automatic['platform'] = 'mac_os_x'
      node.automatic['platform_version'] = '10.10'
      node.set['osquery']['packs'] = %w(osx_pack)
    end.converge(described_recipe)
  end

  let(:osquery_vers) { '1.7.0' }
  let(:domain) { 'com.facebook.osqueryd' }
  osquery_dirs = [
    '/var/log/osquery',
    '/var/osquery/packs'
  ]

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'installs osquery package' do
    expect(chef_run).to install_package('osquery')
      .with(version: osquery_vers)
  end

  osquery_dirs.each do |dir|
    it "creates #{dir}" do
      expect(chef_run).to create_directory(dir)
    end
  end

  it 'installs the a pack' do
    expect(chef_run)
      .to create_cookbook_file('/var/osquery/packs/osx_pack.conf')
  end

  it 'creates osquery config' do
    expect(chef_run).to create_template('/var/osquery/osquery.conf')
  end

  it 'creates osquery LaunchDaemon' do
    expect(chef_run)
      .to create_template("/Library/LaunchDaemons/#{domain}.plist")
  end

  it 'creates osquery syslog conf entry' do
    expect(chef_run).to create_cookbook_file("/etc/newsyslog.d/#{domain}.conf")
  end

  it 'starts and enables osquery service' do
    expect(chef_run).to enable_service(domain)
    expect(chef_run).to start_service(domain)
  end

  it 'notifies to run permission mod' do
    package = chef_run.package('osquery')
    expect(package).to notify('execute[osqueryd permissions]').to(:run).immediately
  end

  it 'modifies osquery binary permissions' do
    expect(chef_run).to_not run_execute('chown root:wheel /usr/local/bin/osqueryd')
  end
end
