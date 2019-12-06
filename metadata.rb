# frozen_string_literal: true

name 'osquery'
maintainer 'Jack Naglieri'
maintainer_email 'jacknagzdev@gmail.com'
license 'Apache-2.0'
description 'Install and configure osquery (osquery.io)'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.9.0'

%w[ubuntu centos redhat mac_os_x amazon].each do |os|
  supports os
end

recipe 'osquery::default', 'convergence/audit requirements.'
recipe 'osquery::amazon', 'amazon osquery installation'
recipe 'osquery::centos', 'centos/redhat osquery installation.'
recipe 'osquery::mac_os_x', 'mac os x osquery installation.'
recipe 'osquery::ubuntu', 'ubuntu osquery installation.'
recipe 'osquery::audit', 'chef audits for osquery installation.'

chef_version '>= 12' if respond_to?(:chef_version)
issues_url 'https://github.com/jacknagz/osquery-cookbook/issues' if respond_to?(:issues_url)
source_url 'https://github.com/jacknagz/osquery-cookbook' if respond_to?(:source_url)

depends 'apt'
