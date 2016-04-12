if defined?(ChefSpec)
  def create_osquery_config(conf)
    ChefSpec::Matchers::ResourceMatcher.new(:osquery_conf, :create, conf)
  end
end
