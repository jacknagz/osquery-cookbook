# frozen_string_literal: true

actions :install_ubuntu, :install_centos, :install_os_x, :remove_centos, :remove_ubuntu, :remove_os_x,
        :install_amazon, :remove_amazon
default_action :install_linux

attribute :version, kind_of: String, name_attribute: true
attribute :upgrade, kind_of: [TrueClass, FalseClass]
