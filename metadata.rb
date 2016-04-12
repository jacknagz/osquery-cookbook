name 'osquery'
maintainer 'Jack Naglieri'
maintainer_email 'jnaglierijr@gmail.com'
license 'All rights reserved'
description 'Install and configure osquery'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://github.com/jacknagz/osquery-cookbook/issues'
source_url 'https://github.com/jacknagz/osquery-cookbook'

version '0.2.0'

supports 'mac_os_x'
supports 'ubuntu'

depends 'homebrew'
depends 'apt'
