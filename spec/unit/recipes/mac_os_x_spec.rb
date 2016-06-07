require 'spec_helper'

describe 'osquery::mac_os_x' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'mac_os_x',
      version: '10.10',
      step_into: %w(osquery_conf osquery_pkg)
    ) do |node|
      node.set['osquery']['packs'] = %w(osx_pack)
      node.set['osquery']['version'] = '1.7.4'
    end.converge(described_recipe)
  end

  before do
    stub_command('which git').and_return('/usr/bin/git')
    stub_command('`which osqueryi` -version').and_return('osqueryi version 1.7.2')
  end

  let(:osquery_vers) { '1.7.4' }
  let(:domain) { 'com.facebook.osqueryd' }
  let(:pkg) { "/var/chef/cache/osquery-#{osquery_vers}.pkg" }
  osquery_dirs = %w(/var/log/osquery /var/osquery/packs)

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  osquery_dirs.each do |dir|
    it "creates #{dir}" do
      expect(chef_run).to create_directory(dir)
    end
  end

  it 'downloads osquery pkg' do
    expect(chef_run).to create_remote_file(pkg)
  end

  it 'installs pkg' do
    downloaded_pkg = chef_run.remote_file(pkg)
    expect(downloaded_pkg).to notify("osquery_pkg[#{pkg}]")
      .to(:install).immediately
    expect(chef_run.osquery_pkg(pkg)).to do_nothing
    # expect(chef_run).to run_execute("installer -pkg #{osquery_pkg} -target /")
  end

  it 'installs the a pack' do
    expect(chef_run)
      .to create_cookbook_file('/var/osquery/packs/osx_pack.conf')
      .with(group: 'wheel', user: 'root')
  end

  it 'creates osquery config' do
    expect(chef_run).to create_osquery_config('/var/osquery/osquery.conf')
  end

  it 'creates osquery conf via lwrp' do
    expect(chef_run)
      .to create_template('/var/osquery/osquery.conf')
      .with(group: 'wheel', user: 'root')
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
    package = chef_run.osquery_pkg(pkg)
    expect(package).to notify('execute[osqueryd permissions]')
      .to(:run).immediately
  end

  it 'modifies osquery binary permissions' do
    expect(chef_run)
      .to_not run_execute('chown root:wheel /usr/local/bin/osqueryd')
  end
end
