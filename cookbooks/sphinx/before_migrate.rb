# Change line #2 so we know which sphinx to monitor :)
appname = "appname"
run "cd #{release_path}/config;ln -sfv #{shared_path}/config/sphinx.yml ."
sudo "cd #{release_path}; rm -rf log"
run "cd #{release_path};ln -sfv #{shared_path}/log ."
run "cd #{release_path}/config;mkdir thinkingsphinx"
if ['app_master', 'solo'].include?(node[:instance_role])
  run "cd #{release_path} pkill -f 'searchd' && bundle exec rake thinking_sphinx:configure && bundle exec rake thinking_sphinx:index && bundle exec rake thinking_sphinx:running_start"
  sudo "monit monitor sphinx_#{appname}_3312"
else
  run "cd #{release_path} bundle exec rake thinking_sphinx:configure"
end
