name 'osquery'
maintainer 'Jack Naglieri'
maintainer_email 'jacknagzdev@gmail.com'
license 'Apache 2.0'
description 'Install and configure osquery (osquery.io)'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.3.0'

%w(ubuntu centos mac_os_x).each do |os|
  supports os
end

chef_version '>= 12' if respond_to?(:chef_version)
issues_url 'https://github.com/jacknagz/osquery-cookbook/issues' if respond_to?(:issues_url)
source_url 'https://github.com/jacknagz/osquery-cookbook' if respond_to?(:source_url)

depends 'homebrew'
depends 'apt'
depends 'compat_resource'
