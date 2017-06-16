actions :install_ubuntu, :install_centos, :install_os_x, :remove_centos, :remove_ubuntu, :remove_os_x
default_action :install_linux

attribute :version, kind_of: String, name_attribute: true
attribute :upgrade, kind_of:  [TrueClass, FalseClass]
