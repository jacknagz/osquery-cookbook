if defined?(ChefSpec)
  def create_osquery_config(conf)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_conf, :create, conf)
  end

  def delete_osquery_config(conf)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_conf, :delete, conf)
  end

  def create_osquery_syslog(syslog_file)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_syslog, :create, syslog_file)
  end

  def delete_osquery_syslog(syslog_file)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_syslog, :delete, syslog_file)
  end

  def install_osquery_pkg(pkg_path)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_pkg, :install, pkg_path)
  end

  def remove_osquery_pkg(pkg_path)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_pkg, :remove, pkg_path)
  end

  def install_osquery_ubuntu(version)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_install, :install_ubuntu, version)
  end

  def remove_osquery_ubuntu(version)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_install, :remove_ubuntu, version)
  end

  def install_osquery_centos(version)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_install, :install_centos, version)
  end

  def remove_osquery_centos(version)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_install, :remove_centos, version)
  end

  def install_osquery_os_x(version)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_install, :install_os_x, version)
  end

  def remove_osquery_os_x(version)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_install, :remove_os_x, version)
  end

  ChefSpec.define_matcher :osquery_pkg
  ChefSpec.define_matcher :osquery_syslog
  ChefSpec.define_matcher :osquery_conf
  ChefSpec.define_matcher :osquery_install
end
