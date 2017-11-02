# FIM enable/disable.
default['osquery']['fim_enabled'] = false
default['osquery']['file_paths'] = {}
# FIM path examples.
# default['osquery']['file_paths']['homes'] = ['/home/%/.ssh/%%']
# default['osquery']['file_paths']['etc'] = ['/etc/%%']
# default['osquery']['file_paths']['tmp'] = ['/tmp/%%']

default['osquery']['exclude_paths'] = {}
# FIM path exclude examples.
# NOTE: Category *must* already exist in file_paths to work.
# default['osquery']['exclude_paths']['homes'] = ['/home/%/.ssh/secret.key']
# default['osquery']['exclude_paths']['etc'] = ['/etc/nginx/%%']
# default['osquery']['exclude_paths']['tmp'] = ['/tmp/awesomeprogram/']
