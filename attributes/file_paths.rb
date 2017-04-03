# FIM configuration.
default['osquery']['fim_enabled'] = false
default['osquery']['file_paths']['homes'] = ['/home/%/.ssh/%%']
default['osquery']['file_paths']['etc'] = ['/etc/%%']
default['osquery']['file_paths']['tmp'] = ['/tmp/%%']
