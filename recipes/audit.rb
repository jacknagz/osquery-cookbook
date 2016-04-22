#
# Cookbook Name:: osquery
# Recipe:: install_audit
#
# Copyright 2016, Jack Naglieri
#
osquery_conf = osquery_config_path

case node['platform']
when 'mac_os_x'
  control_group 'correct osquery os x installation' do
    control 'osquery.conf files' do
      it 'should exist' do
        expect(file(osquery_conf)).to exist
        expect(file(osquery_conf)).to be_file
      end
      it 'should have valid json keys' do
        expect(file(osquery_conf)).to contain('  "options": {')
        expect(file(osquery_conf)).to contain('  "schedule": {')
      end
    end
    control 'osquery launch daemon' do
      it 'should exist' do
        expect(file('/Library/LaunchDaemons/com.facebook.osqueryd.plist'))
          .to exist
        expect(file('/Library/LaunchDaemons/com.facebook.osqueryd.plist'))
          .to be_file
      end
    end
    control 'osquery package' do
      it 'should be installed' do
        expect(package('osquery')).to be_installed
      end
      it 'should be running' do
        expect(service('com.facebook.osqueryd')).to be_running
      end
    end
  end

when 'centos', 'ubuntu', 'redhat'
  control_group 'correct osquery linux installation' do
    control 'osquery.conf files' do
      it 'should exist' do
        expect(file(osquery_conf)).to exist
        expect(file(osquery_conf)).to be_file
      end
      it 'should have valid json keys' do
        expect(file(osquery_conf)).to contain('  "options": {')
        expect(file(osquery_conf)).to contain('  "schedule": {')
      end
    end
    control 'osquery package' do
      it 'should be installed' do
        expect(package('osquery')).to be_installed
      end
      it 'should be running' do
        expect(service('osqueryd')).to be_running
      end
    end
  end
end
