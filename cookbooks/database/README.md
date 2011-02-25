Database cookbook
===============

This cookbook presents one path to automate having database.yml
customized with your changes such as a different [driver][2] (e.g. mysql2).
The goal of this recipe is to properly automate database.yml and create
a keep file so the AppCloud automation does not overwrite your custom
database.yml

This cookbook is provided as-is and has no warranty and/or support.  It
should work as is provided you have the neccesary dependency included
and have this enabled in your main recipe.

with the mysql2 adapter always.  It only has one dependency and that is
the [dnapi][1] cookbook.

[1]: https://github.com/damm/ey-cloud-recipes/tree/master/cookbooks/dnapi
[2]: https://github.com/damm/ey-cloud-recipes/blob/master/cookbooks/database/recipes/default.rb#L10
