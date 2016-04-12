if defined?(ChefSpec)
  def create_osquery_config(conf)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_conf, :create, conf)
  end

  def delete_osquery_config(conf)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_conf, :delete, conf)
  end
end
