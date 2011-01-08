mysql2 cookbook
===============

This cookbook presents one path to automate having database.yml always
have the 'mysql2' driver selected and have it automated so if you
terminate/boot a new instance it will not have incorrect db_master
settings.

This cookbook is provided as-is and has no warranty and/or support.  It
should work as is provided you have the neccesary dependency included
and have this enabled in your main recipe.

with the mysql2 adapter always.  It only has one dependency and that is
the [dnapi][1] cookbook.

[1]: https://github.com/damm/ey-cloud-recipes/tree/master/cookbooks/dnapi
