#uncomment to turn on sphinx
#require_recipe "sphinx"

#uncomment to run the authorized_keys recipe
#require_recipe "authorized_keys"

#uncomment to run the eybackup_slave recipe
#require_recipe "eybackup_slave"

#uncomment to run the resque recipe
#require_recipe "resque"

#uncomment to run the resque-web recipe
#require_recipe "resque_web"

#uncomment to run the eybackup_verbose recipe
#require_recipe "eybackup_verbose"

#require_recipe "node"
#require_recipe "cron_check"
require_recipe "postgresql9::default"
require_recipe "redis-src"
#require_recipe "ffmpeg"
#require_recipe "god"
#require_recipe "god::unicorn"
