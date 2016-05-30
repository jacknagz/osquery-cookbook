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
end
