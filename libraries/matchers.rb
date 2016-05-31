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

  ChefSpec.define_matcher :osquery_pkg

  def install_osquery_pkg(pkg_path)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_pkg, :install, pkg_path)
  end

  def remove_osquery_pkg(pkg_path)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_pkg, :remove, pkg_path)
  end
end
