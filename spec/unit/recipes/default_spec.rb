require 'chefspec'

describe 'osquery-pkg::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.automatic['platform'] = 'mac_os_x'
      node.set['osquery']['packs'] = ['hardware-monitoring']
    end.converge(described_recipe)
  end

  let(:osquery_vers) { '1.6.1' }
  let(:domain) { 'com.facebook.osqueryd' }

  osquery_dirs = ['/var/log/osquery', '/var/osquery/packs']

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'installs osquery package' do
    expect(chef_run).to install_package('osquery').with(version: osquery_vers)
  end

  osquery_dirs.each do |dir|
    it "creates #{dir}" do
      expect(chef_run).to create_directory(dir)
    end
  end

  it 'installs the hardware-monitoring pack' do
    expect(chef_run)
      .to create_cookbook_file('/var/osquery/packs/hardware-monitoring.conf')
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
end
